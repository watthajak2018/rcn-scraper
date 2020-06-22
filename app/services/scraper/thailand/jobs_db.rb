class Thailand
  class JobsDB
    DEFAULT_OPTIONS = {
      title: 'JobsDB',
      base_url: 'https://th.jobsdb.com/TH/en/Search/FindJobs?AD=7&Blind=1&Host=J%2cS&JobCat=131&JSRV=1',
      param: '&page=',
      job: {
        wrapper: {
          selector: '#JobListingSection .result-sherlock-cell',
          type: :container
        },
        total: {
          selector: '#firstLineCriteriaContainer.criteria-primary em',
          type: :text
        },
      },
      jobs: {
        company_name: {
          selector: '.job-company',
          type: :text
        },
        company_url: {
          selector: '.job-company a',
          type: :href
        },
        job_title: {
          selector: '.job-title',
          type: :text
        },
        job_url: {
          selector: '.job-title a',
          type: :href
        }
      }
    }.freeze
  end
end
