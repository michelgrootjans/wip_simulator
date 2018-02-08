describe "Project initialization" do
  it "with symbol-based process" do
    board = KanbanBoard.new({development: {from: :todo, to: :done}}, [])
    expect(board.columns.keys).to eq [:todo, :development, :done]
  end

  it "with string-based process" do
    board = KanbanBoard.new({"development" => {"from" => "todo", "to" => "done"}}, [])
    expect(board.columns.keys).to eq [:todo, :development, :done]
  end
end