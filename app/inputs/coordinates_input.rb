# frozen_string_literal: true

class CoordinatesInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      array_wrapping do
        legend_html <<
          array_inputs_wrapping do
            Array.new(2) do |i|
              array_input_wrapping do
                array_input_html(values[i])
              end
            end.join("\n").html_safe
          end
      end
    end
  end

  private

  def values
    return [nil, nil] if @object.coordinates.nil?

    values = []
    2.times do |i|
      values << object[method][i]
    end

    values
  end

  def array_input_html(value)
    # template.content_tag(:div) do
    template.text_field_tag("#{object_name}[#{method}][]", value, id: nil)
    # end
  end

  def array_wrapping(&block)
    template.content_tag(:fieldset,
                         template.capture(&block),
                         class: "array")
  end

  def array_inputs_wrapping(&block)
    template.content_tag(:ol,
                         template.capture(&block),
                         class: "array-inputs")
  end

  def array_input_wrapping(&block)
    template.content_tag(:li,
                         template.capture(&block),
                         class: "array-input")
  end

  def legend_html
    if render_label?
      template.content_tag(:legend,
                           template.content_tag(:label, 'Coordonnées GPS (latitude, longitude)'),
                           label_html_options.merge(class: "label"))
    else
      "".html_safe
    end
  end
end
