using SerializingChannels
using Test
using TypeSerializers

@testset "SerializingChannels" begin
    integer_value = 42
    c = Channel{Vector{UInt8}}(1)
    integer_channel = SerializingChannel{Int, Channel{Vector{UInt8}}, SerializationTypeSerializer{Int}}(c)
    @test !isready(integer_channel)
    @test !isready(c)
    put!(integer_channel, integer_value)
    @test isready(integer_channel)
    @test isready(c)
    @test take!(integer_channel) == integer_value
end
