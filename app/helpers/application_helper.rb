# frozen_string_literal: true

module ApplicationHelper
  def link_to_genron_sf(url)
    link_to(
      icon('fas', 'external-link-alt', '超・SF作家育成サイトで詳細を確認'), url,
      class: 'btn btn-outline-primary', target: '_blank', rel: 'noopener',
    )
  end
end
