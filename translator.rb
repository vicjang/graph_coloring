
puts "\n"
# the file name comes from command line argument
if ARGV.size < 2
    raise "missing argument. \n\n > USAGE:\n      ruby THIS_FILE [inputFile] [number of colors] [outputFile(optional)]\n\n"
elsif ARGV.size > 3
    raise "too many arguments. \n\n > USAGE:\n      ruby THIS_FILE [inputFile] [number of colors] [outputFile(optional)]\n\n"
else
    #file = ARGV[0].chomp
    file = ARGV[0]
    puts " > Input file            :   #{file}\n"
    colorNum = ARGV[1].to_i
    puts " > Upper bound of colors :   #{colorNum}\n\n"
    if ARGV[2] == nil
        outputFile = ARGV[0].split(".")[0].concat(".lp")
    else
        outputFile = ARGV[2]
    end
end

# variables
nodesNum = 0
output = ""



# write the objective
output << "Minimize\n    obj: "
colorNum.times do |i|
    output << "w#{i+1} + "
end
# remove the last 3 characters " + "
output.chomp!(" + ")
output << "\n\n"

# write the constraints

output << "Subject To\n"
condition_count = 1
File.readlines(file).each_with_index do |line, idx|
    if idx == 0
        nodesNum = line.to_i

        nodesNum.times do |node|
            output << "    c#{condition_count}:  "
            condition_count = condition_count + 1

            colorNum.times do |color|
                output << "x#{node+1}#{color+1} + "
            end

            output.chomp!(" + ")
            output << " = 1\n"
        end

    else
        ab = line.split
        colorNum.times do |color|
            output << "    c#{condition_count}:  "
            condition_count = condition_count + 1
            output << "x#{ab[0]}#{color+1} + x#{ab[1]}#{color+1} <= 1\n"
        end
    end
end

# write the constraints that sets the W's
output << "\\ the constraints that sets the W's\n"
nodesNum.times do |node|
    colorNum.times do |color|
        output << "    c#{condition_count}:  "
        condition_count = condition_count + 1
        output << "x#{node+1}#{color+1} - w#{color+1} <= 0\n"
    end
end


# write the Binary
output << "Binary\n    "
iter = 0
colorNum.times do |color|
    nodesNum.times do |node|
        output << "x#{node+1}#{color+1} "
        iter = iter + 1
        if iter % 10 == 0
            output << "\n    "
        end
    end
end
output << "\n"
colorNum.times do |color|
    output << "w#{color+1} "
    if (color+1) % 10 == 0
        output << "\n    "
    end
end
output << "\nEnd"

# write output to file
File.open( "#{outputFile}", 'w' ) { |file| file.write( output ) }

puts " > SUCCESS: cplex problem successfully written to  << #{outputFile} >>\n\n"

