module PageSerializer
  class ProposedNegativeStatutoryInstrumentsShowPageSerializer < LaidThingShowPageSerializer
    # Initialise a Proposed Negative Statutory Instruments show page serializer.
    #
    # @param [<Grom::Node>] proposed_negative_statutory_instrument a Grom::Node object of type ProposedNegativeStatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(proposed_negative_statutory_instrument:, request_id: nil, data_alternates: nil, request_original_url: nil)
      @proposed_negative_statutory_instrument = proposed_negative_statutory_instrument
      @following_statutory_instruments        = @proposed_negative_statutory_instrument.statutory_instrument_papers

      super(laid_thing: @proposed_negative_statutory_instrument, request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @proposed_negative_statutory_instrument.name
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_objects, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ subheading_content: 'proposed-negative-statutory-instruments.show.subheading', heading_content: title }).to_h]
    end

    def connected_statutory_instruments
      @following_statutory_instruments.map do |stat_instrument|
        ComponentSerializer::LinkComponentSerializer.new(
          link:    "/statutory-instruments/#{stat_instrument.graph_id}",
          content: stat_instrument.name
        ).to_h
      end
    end

    def connected_statutory_instruments_title
      'proposed-negative-statutory-instruments.show.preceding-title'
    end
  end
end
