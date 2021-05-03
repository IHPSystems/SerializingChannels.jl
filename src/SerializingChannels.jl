module SerializingChannels

using TypeSerializers

export SerializingChannel, put!, take!, isready, fetch, close, isopen, bind, iterate

struct SerializingChannel{T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    channel::TChannel
end

function Base.put!(channel::SerializingChannel{T, TChannel, TSerializer}, value::T) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    stream = serialize(TSerializer, value)
    data = take!(stream)
    put!(channel.channel, data)
end

function Base.take!(channel::SerializingChannel{T, TChannel, TSerializer})::T where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    message = take!(channel.channel)
    stream = IOBuffer(message)
    return deserialize(TSerializer, stream)
end

function Base.isready(channel::SerializingChannel{T, TChannel, TSerializer}) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    return isready(channel.channel)
end

function Base.fetch(channel::SerializingChannel{T, TChannel, TSerializer}) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    message = fetch(channel.channel)
    stream = IOBuffer(message)
    return deserialize(TSerializer, stream)
end

function Base.close(channel::SerializingChannel{T, TChannel, TSerializer}) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    return close(channel.channel)
end

function Base.isopen(channel::SerializingChannel{T, TChannel, TSerializer}) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    return isopen(channel.channel)
end

function Base.bind(channel::SerializingChannel{T, TChannel, TSerializer}, task::Task) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    return bind(channel.channel, task)
end

function Base.iterate(channel::SerializingChannel{T, TChannel, TSerializer}, state::Any=nothing) where {T, TChannel <: AbstractChannel{Vector{UInt8}}, TSerializer <: AbstractTypeSerializer{T}}
    if (isopen(channel))
        return (take!(channel), nothing)
    end
    return nothing
end

end # module
