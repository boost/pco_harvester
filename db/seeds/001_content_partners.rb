# frozen_string_literal: true

[
  { name: 'AntarcticaNZ' },
  { name: 'AWS Comprehend' },
  { name: 'Beacon Pathway Ltd' },
  { name: 'Central Hawkes Bay Museum' },
  { name: 'Central Otago Memory Bank' },
  { name: 'Cromwell Museum' },
  { name: 'Culture Grid' },
  { name: 'FigShare' },
  { name: 'Figure nz' },
  { name: 'Howick Historical Village' },
  { name: 'Huntly Museum Te Whare Taonga O Raahui Pookeka' },
  { name: 'ManyAnswers' },
  { name: 'Massey University' },
  { name: 'National Army Museum' },
  { name: 'National Digital Forum' },
  { name: 'New Zealand Police' },
  { name: 'New Zealand Portrait Gallery' },
  { name: 'NZ Museums' },
  { name: 'NZ Musician' },
  { name: 'Pitt Rivers Museum' },
  { name: 'Plant and food research' },
  { name: 'Schools' },
  { name: 'Science Learning Hub' },
  { name: 'State Library of Victoria' },
  { name: 'Statistics New Zealand' },
  { name: 'Teviot District Museum' },
  { name: 'Thames Museum' },
  { name: 'Trove' },
  { name: 'Tusk Culture' },
  { name: 'University of Otago' },
  { name: 'University of Waikato' },
  { name: 'Wikimedia Commons' },
  { name: 'Wikipedia' }
].each do |attributes|
  ContentPartner.create(attributes)
end
