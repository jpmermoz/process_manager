class Task

	attr_accessor :user, :pid, :cpu, :mem, :vmz, :rss, :tty, :stat, :start, :time, :command

	def initialize(cols)
		@user = cols[0]
		@pid = cols[1]
		@cpu = cols[2]
		@mem = cols[3]
		@vmz = cols[4]
		@rss = cols[5]
		@tty = cols[6]
		@stat = cols[7]
		@start = cols[8]
		@time = cols[9]
		@command = cols[10, cols.size].join(' ')
	end

	def self.all
		tasks = []
		`ps faxu --width 1000 --no-headers`.split("\n").each do |line|
			tasks << Task.new(line.split(' '))
		end
		tasks
	end

	def self.find(id)
		all.each do |p|
			return p if p.pid == id.to_s
		end

		nil
	end

	def priority
		`awk '{print $18}' /proc/"#{self.pid}"/stat`.gsub!(/[^0-9A-Za-z]/, '')
	end

	def as_json(options = { })
    p = {}
    p[:user] = user
    p[:pid] = pid
    p[:cpu_percentage] = "#{cpu}%"
    p[:memory_percentage] = "#{mem}%"
    p[:virtual_memory_size] = "#{vmz} KiB"
    p[:resident_set_size] = rss
    p[:tty] = tty
    p[:state] = stat
    p[:start_at] = start
    p[:cpu_time] = time
    p[:command] = command
    p[:priority] = priority
    p
	end
end
