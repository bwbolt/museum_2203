require 'rspec'
require './lib/patron'
require './lib/exhibit'
require './lib/museum'

describe Museum do
  it 'exists with attributes' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    expect(dmns).to be_a(Museum)
    expect(dmns.name).to eq('Denver Museum of Nature and Science')
    expect(dmns.exhibits).to eq([])
    expect(dmns.patrons).to eq([])
  end

  it 'can add exhibits' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    expect(dmns.exhibits).to eq([])
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    expect(dmns.exhibits).to eq([gems_and_minerals, dead_sea_scrolls, imax])
  end

  it 'can recommend an exhibit to a patron' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new('Bob', 20)
    patron_1.add_interest('Dead Sea Scrolls')
    patron_1.add_interest('Gems and Minerals')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('IMAX')
    expect(dmns.recommend_exhibits(patron_1)).to eq([gems_and_minerals, dead_sea_scrolls])
    expect(dmns.recommend_exhibits(patron_2)).to eq([imax])
  end

  it 'can admit a patron' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    expect(dmns.patrons).to eq([])
    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expect(dmns.patrons).to eq([patron_1, patron_2, patron_3])
  end

  it 'can return patrons by exhibit interested in' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expect(dmns.patrons_by_exhibit_interest).to eq({ gems_and_minerals => [patron_1],
                                                     dead_sea_scrolls => [patron_1, patron_2, patron_3],
                                                     imax => [] })
  end

  it 'can return an array of ticket lottery contestants' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq([patron_1, patron_3])
  end

  it 'can draw a lottery winner' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)
    expected = %w[Johnny Bob]
    expect(expected).to include(dmns.draw_lottery_winner(dead_sea_scrolls))
    expect(dmns.draw_lottery_winner(gems_and_minerals)).to eq(nil)
  end

  it 'can collect money from patrons' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    tj = Patron.new('TJ', 7)
    tj.add_interest('IMAX')
    tj.add_interest('Dead Sea Scrolls')
    dmns.admit(tj)
    expect(tj.spending_money).to eq(7)
    expect(dmns.revenue).to eq(0)
    patron_1 = Patron.new('Bob', 10)
    patron_1.add_interest('Dead Sea Scrolls')
    patron_1.add_interest('IMAX')
    dmns.admit(patron_1)
    expect(patron_1.spending_money).to eq(0)
    expect(dmns.revenue).to eq(10)
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('IMAX')
    patron_2.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_2)
    expect(patron_2.spending_money).to eq(5)
    expect(dmns.revenue).to eq(25)
    morgan = Patron.new('Morgan', 15)
    morgan.add_interest('Gems and Minerals')
    morgan.add_interest('Dead Sea Scrolls')
    dmns.admit(morgan)
    expect(morgan.spending_money).to eq(5)
    expect(dmns.revenue).to eq(35)
  end

  it 'catalogues patrons that have visited the exhibits' do
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)
    tj = Patron.new('TJ', 7)
    tj.add_interest('IMAX')
    tj.add_interest('Dead Sea Scrolls')
    dmns.admit(tj)
    patron_1 = Patron.new('Bob', 10)
    patron_1.add_interest('Dead Sea Scrolls')
    patron_1.add_interest('IMAX')
    dmns.admit(patron_1)
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('IMAX')
    patron_2.add_interest('Dead Sea Scrolls')
    dmns.admit(patron_2)
    morgan = Patron.new('Morgan', 15)
    morgan.add_interest('Gems and Minerals')
    morgan.add_interest('Dead Sea Scrolls')
    dmns.admit(morgan)
    expect(dmns.patrons_of_exhibits).to eq({
                                             dead_sea_scrolls => [patron_1, morgan],
                                             imax => [patron_2],
                                             gems_and_minerals => [morgan]
                                           })
  end
end
