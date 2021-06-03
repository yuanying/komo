require 'fileutils'

class Komo::Builder

  def build(config, rebuild: false)
    Komo.init(config)
    Komo::Resources.pages.each do |page|
      unless page.dirty? or rebuild
        config.journal.identical(page.destination)
        next
      end

      # copy the resource to the output directory if it is static
      if page.instance_of? Komo::Resources::Static
        config.journal.create_or_update(page)
        FileUtils.mkdir_p ::File.dirname(page.destination)
        # journal.create_or_update(page)
        FileUtils.cp page.path, page.destination
        FileUtils.chmod 0644, page.destination

      # otherwise, layout the resource and write the results to
      # the output directory
      elsif page.type == 'entry' || page.type == 'index' || page.type == 'rdf' || page.type == 'draft'
        config.journal.create_or_update(page)
        Komo::Renderer.write(page)
      end
    end
    FileUtils.touch ::Komo.cairn

    nil
  end
end
