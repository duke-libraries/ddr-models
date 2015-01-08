module Ddr
  module Vocab
    class Roles < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/roles/")
      term :administrator, label: "Administrator"
      term :editor, label: "Editor"
      term :contributor, label: "Contributor"
      term :downloader, label: "Downloader"
    end
  end
end
