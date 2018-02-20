using DataFrames
using DataStreams
using Arrow
using Feather


# const filename = "dicttest.feather"
# const filename = "datestest.feather"
# const filename = "basictest.feather"

# s = Feather.Source(filename)


# v = CategoricalArray(["abc", "ab", "abc", ""])
# df = DataFrame(A=[2,3,5,7], B=[2.0, missing, 5.0, 7.0], C=["a", "ab", "abc", "abcd"],
#                D=["a", missing, "ab", "abc"], E=[Date(2018)+Dates.Day(i) for i ∈ 0:3],
#                F=vcat([DateTime(2018)+Dates.Second(i) for i ∈ 0:2], [missing]), G=v,
#                H=Arrow.TimeOfDay{Dates.Millisecond,Int32}[Dates.Time(1) + Dates.Minute(i) for i ∈ 0:3])

# df = DataFrame(A=[true, false, true, false, true],
#                B=[true, missing, false, missing, true])
# 
# 
# Feather.write("booltest.feather", df)
# 
# 
# src = Feather.Source("booltest.feather")
# odf = DataFrame(src)


src = Feather.Source("data/attenu.feather")
col = src.ctable.columns[3]
df = DataFrame(src)
v = df[:station]

odf = Feather.write("test1.feather", df)

src2 = Feather.Source("test1.feather")
col2 = src2.ctable.columns[3]
df2 = DataFrame(src2)
v2 = df2[:station]


# v = categorical(["ab", "abc", missing, "ab", "abcd"])
# d = DictEncoding(v)

# df = DataFrame(A=d)
# Feather.write("dicttest.feather", df)

# src = Feather.Source("dicttest.feather")
# col = src.ctable.columns[1]
# odf = DataFrame(src)


