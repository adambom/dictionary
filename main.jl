using JSON
using _

io = open("dictionary.txt")
lines = readlines(io)
close(io)

lines = map(strip, lines[27:end])

isheader(l) = ismatch(r"^[A-Z\s-_]+$", l)
isdefn(l) = ismatch(r"^Defn:", l)
isword(l) = ismatch(r"^[A-z]+$", l)
getwords(d) = filter(isword, split(d, r"[^A-z]", false))

dictionary = Dict()
word = false
defining  = false
defn = ""
words = {}

for line in lines
    if isheader(line)
        if !haskey(dictionary, line)
            # start looking for definition
            word = line
            push!(words, word)
        end
        continue
    end

    if isdefn(line)
        defn = ""
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
                dictionary[word] = defn
                defining = false
                word = false
                continue
            end

            defn = "$defn $line"
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
