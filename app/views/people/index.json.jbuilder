json.array! @people do |person|

  json.id person.id
  json.name person.display_name
  json.preview_url person.picture.url(:preview)

end