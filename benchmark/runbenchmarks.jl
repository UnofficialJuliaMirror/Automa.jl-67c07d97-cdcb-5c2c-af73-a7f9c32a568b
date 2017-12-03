import Automa
import Automa.RegExp: @re_str
using BenchmarkTools

srand(1234)
data = String(vcat([push!(rand(b"ACGTacgt", 59), UInt8('\n')) for _ in 1:1000]...))

VISUALIZE = false
function writesvg(name, machine)
    dot = joinpath(@__DIR__, "$(name).dot")
    svg = joinpath(@__DIR__, "$(name).svg")
    info("writing $(dot)")
    write(dot, Automa.machine2dot(machine))
    info("writing $(svg)")
    run(`dot -Tsvg -o $(svg) $(dot)`)
end


# Case 1
# ------

println("Case 1 ", raw"([A-z]*\r?\n)*")
println("PCRE:                 ", @benchmark ismatch($(r"^(:?[A-z]*\r?\n)*$"), data))

machine = Automa.compile(re"([A-z]*\r?\n)*")
VISUALIZE && writesvg("case1", machine)
context = Automa.CodeGenContext(generator=:goto, checkbounds=false)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl:            ", @benchmark match(data))

context = Automa.CodeGenContext(generator=:goto, checkbounds=false, loopunroll=10)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl (unrolled): ", @benchmark match(data))


# Case 2
# ------

println()
println("Case 2 ", raw"([A-Za-z]*\r?\n)*")
println("PCRE:                 ", @benchmark ismatch($(r"^(:?[A-Za-z]*\r?\n)*$"), data))

machine = Automa.compile(re"([A-Za-z]*\r?\n)*")
VISUALIZE && writesvg("case2", machine)
context = Automa.CodeGenContext(generator=:goto, checkbounds=false)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl:            ", @benchmark match(data))

context = Automa.CodeGenContext(generator=:goto, checkbounds=false, loopunroll=10)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl (unrolled): ", @benchmark match(data))


# Case 3
# ------

println()
println("Case 3 ", raw"([ACGTacgt]*\r?\n)*")
println("PCRE:                 ", @benchmark ismatch($(r"^(:?[ACGTacgt]*\r?\n)*$"), data))

machine = Automa.compile(re"([ACGTacgt]*\r?\n)*")
VISUALIZE && writesvg("case3", machine)
context = Automa.CodeGenContext(generator=:goto, checkbounds=false)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl:            ", @benchmark match(data))

context = Automa.CodeGenContext(generator=:goto, checkbounds=false, loopunroll=10)
@eval function match(data)
    $(Automa.generate_init_code(context, machine))
    p_end = p_eof = endof(data)
    $(Automa.generate_exec_code(context, machine))
    return cs == 0
end
println("Automa.jl (unrolled): ", @benchmark match(data))
