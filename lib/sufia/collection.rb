require 'datastreams/collection_rdf_datastream'
require 'datastreams/properties_datastream'

module Sufia
  module Collection
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload
    autoload :Permissions
    include Sufia::ModelMethods
    include Sufia::Noid  
    include Sufia::GenericFile::Permissions
                                                

    included do
      has_metadata :name => "descMetadata", :type => CollectionRdfDatastream
      has_metadata :name => "properties", :type => PropertiesDatastream

      belongs_to :batch, :property => :is_part_of
      has_and_belongs_to_many :generic_files, :property => :hasCollectionMember, :inverse_of => :isMemberOfCollection, 

      delegate_to :properties, [:depositor], :unique => true
      delegate_to :descMetadata, [:date_uploaded, :date_modified, :related_url,
                                  :title, :description], :unique => true
    end

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      solr_doc["noid_s"] = noid
      return solr_doc
    end

    def terms_for_editing
      terms_for_display - [:date_modified, :date_uploaded]
    end

    def terms_for_display
      self.descMetadata.class.config.keys
    end
  end
end