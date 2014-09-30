using JSON
using _

io = open("dictionary.txt")
lines = readlines(io)
close(io)

lines = map(strip, lines[27:end])

isheader(l) = ismatch(r"^[A-Z\s-_]+$", l)
isdefn(l) = ismatch(r"^Defn:", l)
isword(l) = ismatch(r"^[A-z]+$", l)
isnumdefn(l) = ismatch(r"^(\d+)(\.)( )", l)

getwords(d) = filter(isword, split(d, r"[^A-z]", false))

function parse()
    dictionary = Dict()
    word = false
    defining = false
    defn = ""
    words = {}
    numLines = length(lines)
    for lineNum = 1:numLines
        line = lines[lineNum]
        if isheader(line)
            if defining
                dictionary[word] = defn
                i = length(defn)
                if i > 50
                    i = 50
                end
                # println(string("Setting ", word, " as ", defn[1:i]))
                defining = false
                word = false
                defn = ""
            end
            if !haskey(dictionary, line)
                # start looking for definition
                word = line
                push!(words, word)
            else
                # instead of skipping duplicate defintions, add as WORD#1, etc.
                i = 1
                wordLength = length(line)
                while haskey(dictionary, line)
                    line = string(line[1:wordLength], "#", i)
                    i = i + 1
                end
                word = line
                push!(words, word)
            end
            continue
        end

        if isdefn(line) || isnumdefn(line)
            if word != false
                # begin reading definition
                defining = true
                replaced = replace(line, "Defn: ", "")
                defn = "$defn$replaced"
            end
            continue
        end

        if defining
            if word != false
                if line == ""
                    if !isnumdefn(lines[lineNum + 1]) || !isdefn(lines[lineNum + 1])
                        dictionary[word] = defn
                        # println(string("Setting ", word, " as ", defn))
                        defining = false
                        word = false
                        defn = ""
                        continue
                   else
                       defn = string(defn, " && ")
                   end
                else
                    defn = "$defn $line"
                end
            end
        end
    end

    io = open("dictionary.json", "w+")
    JSON.print(io, dictionary)

    close(io)

    nodes = unique(keys(dictionary))

    graph = Dict()

    # Build a graph representation
    for node in nodes
        definition = dictionary[node]
        try
            words = getwords(definition)
        catch x
            println("Error on word: $node. Defn: $definition")
            continue
        end
        words = _.without(words, node)
        graph[node] = map(uppercase, words)
    end

    io = open("graph.json", "w+")
    JSON.print(io, graph)
    close(io)
end

parse()
