json.array! @features do |feature|

  json.id feature.id
  json.preview_url feature.picture.url(:preview)

end