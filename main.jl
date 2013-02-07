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

for line in lines
    if isheader(line)
        if !has(dictionary, line)
            # start looking for definition
            word = line
        end
        continue
    end

    if isdefn(line)
        defn = ""
        if word != false
            # begin reading definition
            defining = true
            defn = strcat(defn, replace(line, "Defn: ", ""))
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

            defn = strcat(defn, line)
        end
    end
end

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
print_to_json(io, graph)
close(io)
