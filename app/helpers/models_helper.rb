module ModelsHelper
  extend Deprecation

  def admin_set_full_name(slug)
    Deprecation.warn(self, "admin_set_full_name helper method is deprecated and will be removed in v3." \
                           " Retrieve admin set title from AdminSet ActiveResource instead.")
    I18n.t("ddr.admin_set.#{slug}")
  end

end
