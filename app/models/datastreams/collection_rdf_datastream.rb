# Copyright © 2012 The Pennsylvania State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class CollectionRdfDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(:in => RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.description(:in => RDF::DC) do |index|
      index.type :text
      index.as :searchable, :displayable
    end
    map.date_uploaded(:to => "dateSubmitted", :in => RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end
    map.date_modified(:to => "modified", :in => RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end
  end
end
