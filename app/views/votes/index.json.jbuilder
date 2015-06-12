json.index do
  @votes.each do |combination, count|
    json.set! "#{combination[0]}-#{combination[1]}", count
  end
end

json.items do
  json.array! @votes do |combi|
    json.feature_id combi[0][0]
    json.person_id combi[0][1]
    json.count combi[1]
  end
end