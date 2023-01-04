#!/usr/bin/ruby


require 'json'
require 'fileutils'


#############
## CONFIGS ##
#############


CC_CONFIG_PATH = "./_site/_cloudcannon"
CC_CONFIG_FILE = "#{CC_CONFIG_PATH}/info.json"
CC_CONFIG_EN = "./_site/en/_cloudcannon/info.json"
CC_CONFIG_ES = "./_site/es/_cloudcannon/info.json"
CC_CONFIG_PTBR = "./_site/pt-br/_cloudcannon/info.json"

CC_CONFIG_LIST = [
    CC_CONFIG_EN,
    CC_CONFIG_ES,
    CC_CONFIG_PTBR
]


###################
## CLASS EXTENDS ##
###################


class ::Hash
    # https://www.jvt.me/posts/2019/09/07/ruby-override-merge-nested-array-hash/
    def deep_merge_override(second)
        merger = proc do |key, original, override|
        if original.instance_of?(Hash) && override.instance_of?(Hash)
            original.merge(override, &merger)
        else
            if original.instance_of?(Array) && override.instance_of?(Array)
            # if the lengths are different, prefer the override
            if original.length != override.length
                override
            else
                # if the first element in the override's Array is a Hash, then we assume they all are
                if override[0].instance_of?(Hash)
                original.map.with_index do |v, i|
                    # deep merge everything between the two arrays
                    original[i].merge(override[i], &merger)
                end
                else
                    # if we don't have a Hash in the override,
                    # override the whole array with our new one
                    override
                end
            end
            else
                override
            end
        end
        end
        self.merge(second.to_h, &merger)
    end
end


#############
## METHDOS ##
#############


def read_file(path, mode='r')
    return JSON.parse(
        File.open(path, mode) {| f|
            f.flock(File::LOCK_SH)
            p f.read
        }
    )
end

def write_file(filename, mode='w', content)
    file = File.new(filename, mode)
    file.write(content)
    file.close()
end

def create_folder(foldername)
    FileUtils.mkdir_p(foldername) unless File.exist?(foldername)
end

def merge_file(content, content_to_merge)
    return content.merge(content_to_merge) {  }
end

def merge_file_recursively(content, content_to_merge)
    content.deep_merge_override(content_to_merge)
end


###########
## EXEC ##
##########


en_content = read_file(CC_CONFIG_EN)
es_content = read_file(CC_CONFIG_ES)
ptbr_content = read_file(CC_CONFIG_PTBR)

merged_content = merge_file_recursively(ptbr_content, es_content)
merged_content = merge_file_recursively(merged_content, en_content)

# merged_content = merge_file(main_content, ptbr_content)
# main_content = merged_content

create_folder(CC_CONFIG_PATH)
write_file(CC_CONFIG_FILE, JSON.generate(merged_content))
