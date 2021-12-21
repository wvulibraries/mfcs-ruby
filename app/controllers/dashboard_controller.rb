class DashboardController < ApplicationController
  # GET /dashboard
  def index
    @total_digital_objects = Item.where(metadata: false).count
    @total_metadata_objects = Item.where(metadata: true).count

    @media_count = Media.all.count
    @item_count = Item.all.count

    @form_count = Form.all.count
    @object_form_count = Form.object_forms.count
    @object_forms_production_count = Form.object_production_forms.count
    @metadata_form_count = Form.metadata_forms.count
    @metadata_forms_production_count = Form.metadata_production_forms.count

    fs_to_check = '/boot'
    df_output = `df #{fs_to_check}`
    disk_line = df_output.split("\n")[1]

    disk_used_bytes = disk_line.match(/(.+)\s+(\d+)\s+(\d+)\s+(\d+)\s+/)[3].to_i
    disk_free_bytes = disk_line.match(/(.+)\s+(\d+)\s+(\d+)\s+(\d+)\s+/)[4].to_i

    disk_used_mbs = disk_used_bytes / 1024
    disk_used_gb = disk_used_mbs / 1024

    disk_free_mbs = disk_free_bytes / 1024
    disk_free_gb = disk_free_mbs / 1024

    @gb_available = disk_free_gb.to_s + ' GB'
    @gb_used = disk_used_gb.to_s + ' GB'
    @total_space = (disk_used_gb + disk_free_gb).to_s + ' GB'

    # Get data folder size
    @data_folder_usage = `du -sh \data`.to_i.to_s + ' MB' # gsub(/\s.+/, '')

    @tif_count = Media.where(mime_type: 'image/tiff').count

    @archive_count = Media.where(media_type: 'archive').count
    @working_count = Media.where(media_type: 'working').count
    @thumbnail_count = Media.where(media_type: 'thumbnail').count
    @conversion_count = Media.where(media_type: 'conversion').count
  end

  # GET /dashboard/duplicates
  def duplicates
    breadcrumb 'Dashboard', '/dashboard', title: 'Dashboard', match: :exact
    breadcrumb 'Duplicates', '/dashboard/duplicates', title: 'Duplicates', match: :exact

    # find duplicate checksums
    duplicate_checksums = Media.where(media_type: :working).select(:checksum).group(:checksum).having('count(*) > 1').size

    @medias = []
    duplicate_checksums.each do |key, _value|
      @medias.concat(Media.where(media_type: :working, checksum: key.to_s))
    end
  end

  # GET /dashboard/permissions
  def permissions_audit
    breadcrumb 'Dashboard', '/dashboard', title: 'Dashboard', match: :exact
    breadcrumb 'Permissions', '/dashboard/permissions', title: 'Permissions Information',
                                                        match: :exact
  end

  # GET /dashboard/fixity
  def fixity_history
    breadcrumb 'Dashboard', '/dashboard', title: 'Dashboard', match: :exact
    breadcrumb 'Fixity', '/dashboard/fixity', title: 'Fixity History', match: :exact
  end

  # GET /dashboard/obsolete
  def obsolete
    breadcrumb 'Dashboard', '/dashboard', title: 'Dashboard', match: :exact
    breadcrumb 'Obsolete', '/dashboard/obsolete', title: 'Obsolete Files', match: :exact
  end

  # GET /dashboard/virus
  def virus
    breadcrumb 'Dashboard', '/dashboard', title: 'Dashboard', match: :exact
    breadcrumb 'Virus', '/dashboard/virus', title: 'Virus History', match: :exact
  end
end
