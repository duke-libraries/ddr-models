module ModelsHelper

  def admin_set_full_name(slug)
    I18n.t("ddr.admin_set.#{slug}")
  end

end