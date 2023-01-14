using DelimitedFiles
using Pipe

input_array = @pipe readdlm(joinpath(@__DIR__,"..","inputs","day25.txt"),' ',String)

result = ["0" for i in 1:25]

snafu_dict = Dict('=' => -2, '-' => -1, '0' => 0, '1' => 1, '2' => 2,
    -2 => '=', -1 => '-', 0 => '0', 1 => '1', 2 => '2')

function snafu_unary_sum(a,b)
    res = snafu_dict[a] + snafu_dict[b]
    bit = 0
    carry = 0
    res == 4 && return snafu_dict[], snafu_dict[]
    return bit, carry
end

function snafu_to_decimal(row)
    decimal = 0
    row_length = length(row)
    for (index,sign) in enumerate(row)
        sign_num = row_length - index
        decimal += (5 ^ (sign_num)) * snafu_dict[sign]
    end
    decimal
end

function decimal_to_snafu(number)
    
end

function test_aa(aaa)
    if aaa / 5 ^ Int(floor(log(5,aaa))) > 2
        println("YES")
    else
        println("NO")
    end
    
end

function part1(input_array)
    rows_sum = 0
    for row in eachrow(input_array)
        
        rows_sum += snafu_to_decimal(row[1])
    end
    println(rows_sum)
end

part1(input_array)