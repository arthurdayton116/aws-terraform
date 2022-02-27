SELECT DATETIME_FORMAT(build_start_time,'yyyy-MM-dd HH:mm:ss.S') build_start_time,
DATETIME_FORMAT(build_end_time,'yyyy-MM-dd HH:mm:ss.S') build_end_time, BUILD_TAG, build_duration_seconds FROM "created*"
where build_end_time is not null
order by build_start_time desc

SELECT "@timestamp",host.cpu.usage,system.cpu.total.pct, process.cpu.pct FROM "metric*" where host.cpu.usage is not null and "@timestamp" > NOW() - INTERVAL 10 MINUTES
order by "@timestamp"



filters
| essql
  query="SELECT DATETIME_FORMAT(build_start_time,'yyyy-MM-dd HH:mm:ss.S') build_start_time,
DATETIME_FORMAT(build_end_time,'yyyy-MM-dd HH:mm:ss.S') build_end_time, BUILD_TAG, build_duration_seconds FROM \"created*\"
where build_end_time is not null
order by build_start_time desc"
| head
| markdown
  "## Jenkins Build Job Data
  ***
{{#each rows}}
 ### Build Tag: {{BUILD_TAG}}
> **Build Start Time: {{build_start_time}}**
>
> **Build End Time:   {{build_end_time}}**
>
> **Build Duration:   {{build_duration_seconds}}**
{{/each}}
"
| render
  css=".canvasMarkdown h2 {
font-size: 25px !important;
font-weight: bold;
color: white !important;
}
.canvasMarkdown h3 {
font-size: 20px !important;
font-weight: bold;
color: white !important;
}
.canvasMarkdown p {
font-size: 14px !important;
font-weight: bold;
color: white !important;
}
"

filters
| essql
  query="SELECT \"@timestamp\",host.cpu.usage,system.cpu.total.pct, process.cpu.pct FROM \"metric*\" where host.cpu.usage is not null and \"@timestamp\" > NOW() - INTERVAL 10 MINUTES
order by \"@timestamp\""
| pointseries x="@timestamp" y="system.cpu.total.pct"
| plot defaultStyle={seriesStyle points="5" lines="5" color="#1785b0" bars="0"}
  font={font align="left" color="#FFFFFF" family="'Open Sans', Helvetica, Arial, sans-serif" italic=true size=14 underline=true weight="bold"}
| render