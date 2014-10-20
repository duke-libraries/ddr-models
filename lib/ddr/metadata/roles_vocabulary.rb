module Ddr
  module Metadata
    class RolesVocabulary < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/roles#")
      term :administrator, label: "Administrator"
      term :editor, label: "Editor"
      term :contributor, label: "Contributor"
      term :downloader, label: "Downloader"
    end
  end
end
