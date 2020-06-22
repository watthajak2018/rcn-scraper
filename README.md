# RCN Scraper

```bash
rcn-scraper
bundle install
ruby app/services/scraper.rb
```

### Environment Variable (ENV)

Open the `rcn-scraper` directory and edit **environment variable** only used for the app directory.
```bash
cd rcn-scraper
direnv edit .
```

Write the items below.
```bash
export GOOGLE_CLIENT_ID=
export GOOGLE_CLIENT_SECRET=
export SPREADSHEET_ID=
```

- To get `GOOGLE_CLIENT_ID` & `GOOGLE_CLIENT_SECRET`.
Please find more information on [Turn on the Google Sheets API](https://developers.google.com/sheets/api/quickstart/ruby#step_1_turn_on_the).

- To `Configure your OAuth client` please select `Desktop app`.

- To get `SPREADSHEET_ID`.
Please find more information on [Publishing your Google Spreadsheet](https://wiki.mozilla.org/Help:Widget:Google_Spreadsheet/).

![You can also get this id from the url of your spreadsheet](https://wiki.mozilla.org/images/9/91/Google_Spreadsheet_Key_from_url.png)
