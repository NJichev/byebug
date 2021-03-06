require 'byebug/command'
require 'irb'
require 'English'

module Byebug
  #
  # Enter IRB from byebug's prompt
  #
  class IrbCommand < Command
    self.allow_in_post_mortem = true

    def self.regexp
      /^\s* irb \s*$/x
    end

    def self.description
      <<-DESCRIPTION
        irb

        #{short_description}
      DESCRIPTION
    end

    def self.short_description
      'Starts an IRB session'
    end

    def execute
      unless processor.interface.instance_of?(LocalInterface)
        return errmsg(pr('base.errors.only_local'))
      end

      # @todo IRB tries to parse $ARGV so we must clear it (see #197). Add a
      #   test case for it so we can remove this comment.
      with_clean_argv { IRB.start }
    end

    private

    def with_clean_argv
      saved_argv = $ARGV.dup
      $ARGV.clear
      begin
        yield
      ensure
        $ARGV.concat(saved_argv)
      end
    end
  end
end
