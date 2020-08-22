
getoutputlength(version::Int32, x::Integer) = version < FEATHER_VERSION ? x : padding(x)

function validatefile(filename::AbstractString, data::AbstractVector{UInt8})
    if length(data) < MIN_FILE_LENGTH
        throw(ArgumentError("'$file' is not in feather format: total length of file: $(length(data))"))
    end    
    header = data[1:4]
    footer = data[(end - 3):end]
    if header ≠ FEATHER_MAGIC_BYTES || footer ≠ FEATHER_MAGIC_BYTES
        throw(ArgumentError(string("'$filename' is not in feather format: header = $header, ",
            "footer = $footer.")))
    end
end

function loadfile(filename::AbstractString; use_mmap::Bool=true)
    isfile(filename) || throw(ArgumentError("'$filename' is not a valid file."))
    data = use_mmap ? Mmap.mmap(filename) : read(filename)
    validatefile(filename, data)
    data
end

function metalength(data::AbstractVector{UInt8})
    read(IOBuffer(data[(length(data) - 7):(length(data) - 4)]), Int32)
end

function metaposition(data::AbstractVector{UInt8}, metalen::Integer=metalength(data))
    length(data) - (metalen + 7)
end

function rootposition(data::AbstractVector{UInt8}, mpos::Integer=metaposition(data))
    read(IOBuffer(data[mpos:(mpos + 4)]), Int32)
end

function getctable(data::AbstractVector{UInt8})
    metapos = metaposition(data)
    rootpos = rootposition(data, metapos)
    ctable = FlatBuffers.read(Metadata.CTable, data, metapos + rootpos - 1)
    if ctable.version < FEATHER_VERSION
        @warn("This feather file is old and may not be readable.")
    end
    ctable
end
