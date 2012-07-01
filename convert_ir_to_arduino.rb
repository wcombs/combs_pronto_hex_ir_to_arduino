
# num times to repeat the repeat-burst after initial code is sent, 2 should be fine, tweak if you are having issues
num_repeats = 2

puts "type in a var name (can be any string):"
var_name = gets
puts "paste the code (no newlines):"
code = gets

arr = code.split

cur = arr.shift
if cur.to_i(16) != 0
	puts "first word of preamble wasn't 0, not supported yet, exiting..."
	exit
end

cur = arr.shift
# freq in Hz
freq = 1000000/(cur.to_i(16).to_s(10).to_i * 0.241246)
puts "\nsignal details:\n\n"
puts "freq is " + (freq/1000).round(2).to_s + " kHz"

single_cyc_len_ms = 1/freq * 1000000
puts "one cycle length is: " + single_cyc_len_ms.to_s + " milliseconds"

cur = arr.shift
otb_length = cur.to_i(16).to_s(10)
cur = arr.shift
rpb_length = cur.to_i(16).to_s(10)

puts "one-time burst length: " + otb_length + " cycles"
puts "repeat burst length: " + rpb_length + " cycles"

last_pulse = 0
last_delay = 0
same_counter = 1
# one-time burst
puts "\nhere's your code:\n\n"
print "int " + var_name.chomp + "[] = {"
for i in 1..otb_length.to_i
	pulse = arr.shift
	delay = arr.shift

	if pulse == arr[0] && delay == arr[1]
		same_counter += 1
		next
	else
		pulse = pulse.to_i(16).to_s(10).to_i * single_cyc_len_ms.round(0)
		delay = delay.to_i(16).to_s(10).to_i * single_cyc_len_ms.round(0)
		puts same_counter.to_s + ", " + pulse.to_s + ", " + delay.to_s + ","
		same_counter = 1
	end
end

# repeat burst
for i in 1..num_repeats
	for i in 0..(rpb_length.to_i - 1)
		pulse = arr[i]
		delay = arr[i+1]
		pulse = pulse.to_i(16).to_s(10).to_i * single_cyc_len_ms.round(0)
		delay = delay.to_i(16).to_s(10).to_i * single_cyc_len_ms.round(0)
		puts "1, " + pulse.to_s + ", " + delay.to_s + ","
	end
end

#if arr.length != 0
#	puts "some words left, somethings up, invalid code, exiting..."
#	exit
#else
puts "\n"
puts "valid code, success..."
#end

