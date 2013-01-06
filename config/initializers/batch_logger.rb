formatter = Log4r::PatternFormatter.new(:pattern => "%d %C [%l]: %M", :date_format => "%Y/%m/%d %H:%M:%S")
if Rails.env == "development"
  outputter = Log4r::StdoutOutputter.new(STDOUT, :formatter => formatter)
else
  outputter = Log4r::StdoutOutputter.new(File.expand_path("log/batch_log_#{Rails.env}.log", Rails.root), :formatter => formatter)
end
BatchLogger = Log4r::Logger.new("StudyMov")
BatchLogger.add(outputter)