module Railsalitics
  class Formatter
    def call(severity, time, progname, msg)
      {:severity => severity, :time => time, :program => progname, :message => msg}
    end
  end
end
