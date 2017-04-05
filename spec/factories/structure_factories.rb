require 'support/structural_metadata_helper'

FactoryGirl.define do

  factory :structures, class: Ddr::Models::Structure do

    factory :simple_structure do
      initialize_with do
        new(simple_structure_document)
      end
    end

    factory :nested_structure do
      initialize_with do
        new(nested_structure_document)
      end
    end

    factory :nested_structure_mptr do
      initialize_with do
        new(nested_structure_mptr_document)
      end
    end

    factory :multiple_struct_maps_structure do
      initialize_with do
        new(multiple_struct_maps_structure_document)
      end
    end

  end

end
