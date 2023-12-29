class ChangeDatatypeCookedDateOfLunchboxLogs < ActiveRecord::Migration[7.0]
  def change
    change_column :lunchbox_logs, :cooked_date, :datetime
  end
end
