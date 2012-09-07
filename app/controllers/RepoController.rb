class RepoController < UIViewController
  def viewDidLoad
    @data = []

    BW::HTTP.get("https://api.github.com/users/gristmill/repos") do |response|
      json = BW::JSON.parse(response.body.to_str)

      json.each do |j|
        @data << { name: j["full_name"], watchers: j["watchers_count"] }
      end

      @table = UITableView.alloc.initWithFrame(self.view.bounds)

      self.view << @table

      @table.dataSource = self
      @table.delegate   = self
    end

    super
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier ||= "REPO") || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)
    end

    cell.textLabel.text = @data[indexPath.row][:name]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    App.alert("#{@data[indexPath.row][:name]} has #{@data[indexPath.row][:watchers]} watchers.")
  end
end
