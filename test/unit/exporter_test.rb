require 'test_helper'

class ExporterTest < ActiveSupport::TestCase
  test "isolated exporter lib" do
    # make a sample image
    system('mkdir -p public/system/images/1/original')
    system('cp test/fixtures/demo.png public/system/images/1/original/')
    system('mkdir -p public/warps/saugus-landfill-incinerator')
    system('touch public/warps/saugus-landfill-incinerator/folder')
    assert File.exist?('public/warps/saugus-landfill-incinerator/folder')

    scale = 2

    w = warpables(:one)    
    coords = Exporter.generate_perspectival_distort(scale, w.map.slug, w.nodes_array, w.id, w.image_file_name, w.image, w.height, w.width)
    assert_not_nil coords
    assert_not_nil Exporter.delete_temp_files(w.map.slug)
    assert_not_nil Exporter.get_working_directory(w.map.slug)
    assert_not_nil Exporter.warps_directory(w.map.slug)

    map = Map.first
    origin = Exporter.distort_warpables(scale, map.warpables, map.export, map.slug)
    lowest_x, lowest_y, warpable_coords = origin
    assert_not_nil origin
    ordered = false
    # these params could be compressed - warpable coords is part of origin; are coords and origin required?
    assert_not_nil Exporter.generate_composite_tiff(warpable_coords, origin, map.placed_warpables, map.slug, ordered)
    assert_not_nil Exporter.generate_tiles('', map.slug, Rails.root.to_s)
    assert_not_nil Exporter.zip_tiles(map.slug)
    assert_not_nil Exporter.generate_jpg(map.slug, Rails.root.to_s)
    resolution = 20
    assert_not_nil Exporter.run_export(User.last, resolution, map.export, map.id, map.slug, Rails.root.to_s, map.average_scale, map.placed_warpables, '')
  end
end
