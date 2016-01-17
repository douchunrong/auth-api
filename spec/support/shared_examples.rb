shared_examples '*_exist factory' do
  it 'returns one item without argument' do
    expect(subject.call).to have(1).items
  end

  it 'returns items with count' do
    expect(subject.call(count: 2)).to have(2).items
  end

  it 'returns items with count more than attrs_set' do
    expect(subject.call [{},{}], count: 3).to have(3).items
  end

  it 'returns items with count less than attrs_set' do
    expect(subject.call [{},{}], count: 1).to have(1).items
  end

  it 'returns items without count' do
    expect(subject.call [{},{}]).to have(2).items
  end

  it 'returns empty with 0 count' do
    expect(subject.call count: 0).to be_empty
  end

  it 'returns empty with empty attrs_set' do
    expect(subject.call []).to be_empty
  end
end
