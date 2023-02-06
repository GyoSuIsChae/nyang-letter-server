
# frozen_string_literal: true

module RandomNickname
  class Generator
    def self.generate
      "#{verb} #{adjective} #{noun}"
    end

    def self.verb
      data("verb").sample(random: Random)
    end

    def self.adjective
      data("adjective").sample(random: Random)
    end

    def self.noun
      data("noun").sample(random: Random)
    end

    def self.data_path(data_type)
      "#{RandomNickname::BASE_LIB_PATH}/random_nickname/data/#{data_type}"
    end

    def self.data(data_type)
      array = File.read(self.data_path(data_type), mode: "r:UTF-8").split("\n")
      array = shuffle(array)
      p freeze_all(array)
      freeze_all(array)
    end

    def self.shuffle(array)
      array.sort_by { Random.rand }
    end

    def self.freeze_all(array)
      array.each(&:freeze)
      array.freeze
      array
    end
  end
end
