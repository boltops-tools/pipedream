module Pipedream::Utils
  module CallLine
    include Pretty

    def ufo_config_call_line
      call_line = caller.find { |l| l.include?('.pipedream/') }
      pretty_path(call_line)
    end
  end
end

