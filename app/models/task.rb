class Task

	attr_accessor :user, :pid, :cpu, :mem, :vmz, :rss, :tty, :stat, :start, :time, :command, :errors

	def initialize(args = {})
		args.each do |key, value|
			self.instance_variable_set("@#{key}", value)
		end

		@errors = []
	end

	def self.all
		tasks = []
		`ps faxu --width 1000 --no-headers`.split("\n").each do |line|
			tasks << Task.construct(line.split(' '))
		end

		tasks
	end

	def self.find(id)
		all.detect { |p| p.pid == id.to_s }
	end

	def save
		begin
			pid = Process.spawn("#{self.command}")
			p = Task.find(pid)

			self.user = p.user
			self.pid = p.pid
			self.cpu = p.cpu
			self.mem = p.mem
			self.vmz = p.vmz
			self.rss = p.rss
			self.tty = p.tty
			self.stat = p.stat
			self.start = p.start
			self.time = p.time
			self.command = p.command
		rescue Exception => e
			self.errors << e.message
			return false
		end

		true
	end

	def update(task_params)
		priority = task_params[:priority]
		`renice -n "#{priority}" -p "#{self.pid}"`
		true
	end

	def priority
		`ps --no-headers -p "#{self.pid}" -o nice`.gsub!(/[^0-9A-Za-z]/, '')
	end

	def destroy
		begin
			Process.kill(:KILL, self.pid.to_i)
		rescue Exception => e
			self.errors << e.message
			return false
		end

		true
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
    p[:status] = stat
    p[:start_at] = start
    p[:cpu_time] = time
    p[:command] = command
    p[:priority] = priority
    p
	end

	private

	def self.construct(cols = [])
		t = Task.new

		t.user = cols[0]
		t.pid = cols[1]
		t.cpu = cols[2]
		t.mem = cols[3]
		t.vmz = cols[4]
		t.rss = cols[5]
		t.tty = cols[6]
		t.stat = cols[7]
		t.start = cols[8]
		t.time = cols[9]
		t.command = cols[10, cols.size].join(' ')

		t
	end
end
