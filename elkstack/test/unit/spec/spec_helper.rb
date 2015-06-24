# Encoding: utf-8

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

Dir['./test/unit/spec/support/**/*.rb'].sort.each { |f| require f }

def stub_resources
  # overall search stub
  chef_search_query = double('Chef::Search::Query', test_search: { foo: false })
  allow(Chef::Search::Query).to receive(:new).and_return(chef_search_query)

  # elkstack search
  elk_query_str = 'tags:elkstack AND chef_environment:_default AND elasticsearch_cluster_name:elasticsearch AND NOT name:fauxhai.local'
  allow(chef_search_query).to receive(:search).with(:node, elk_query_str).and_return({}) # stub this search

  # logstash search
  logstash_query_str = 'role:loghost'
  logstash_result = { server: { ipaddress: '127.0.0.1' } }
  allow(chef_search_query).to receive(:search).with(:node, logstash_query_str).and_return(logstash_result) # stub this search

  # stub encrypted data bag
  lumberjack_data_bag = double('lumberjack_data_bag')
  allow(Chef::EncryptedDataBagItem).to receive(:load).with('lumberjack', 'secrets').and_return(lumberjack_data_bag)
  # rubocop:disable Metrics/LineLength
  allow(lumberjack_data_bag).to receive(:[]).with('key').and_return('LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRRGdhQXArYkdpa2JKbDQKOU5OMzVLRTdhQkJHYStJcjdicVdxSlB1MVR0VVJadEVnYXNOQ0pZOG9NT3dwSzUweFQvNlBmM2VLK3Rsb1BFbwp0TGxzZlF0SlhIdG5EUlRmQXlFcWI0OUNYWm40RTNtR1B0WmpETGpVUVcva2p2OXhneDVrNzhFdWJXZEVSc090CkVxMi81ak1HVytDam4yVVNZM3ZnSzlXR2FJdkRGUUJhbXI0WFo2Ynl5MkFpZHgwTG9vOEJvQXM1N2tneXM2L3AKS2NLUEZKM2s5aUZlTU5aZ2hOVWkyakdBNXpWMkpRdzU5N1h6NWw0WkhGeHVxL0QzTFREWmNtcGRuQ2k3djRNWApCN2ZFNXNsNTZrZnBNajJqc0RGdVRXTWlPdzBhRkdnQjhuSkloeVZxZVNtUktQWG1ad0pPZVByS0s3em53RVpaCk9NRitqbG5QQWdNQkFBRUNnZ0VBSU9ZZjQ3ancvbW9OZGZZdXFuMFNSaXRUZDMrSmdQY3hTN1ViT3dCMzJqcjYKTUdqeU1zNzNkNXY2RklPUUwvNWJDc3piMHg2TlBERUVLZnVVMDVyaGRMZmlQNUZqWmU2SGhqa2t2NDRKYkowdQpTOGdhbGhyZlhmN1o4S0FtUXZYK0ZyNHZqQ2J0NU15YkUxeVJySGlMTW50MXk0Y3F3aTlqa2RIYlZBRXZ2RUdwCnBkczZuVjR0aGwvOHJjb3kzc0dXZEdGMWl4UzVaeFNlbVhOb2Znc3pZbGZRZVZEN1BqazBPMU9VeVJYc0VqTGEKM2ZlbFJSeG52RGZ3QjlURlo2ckVjL0tBUzZwQSs2Tm1SV3lMZThITElHamlzSzArbFUwV2t3U0daUm0yaDhZWgprQWFWNGFxb3J1MHgwT0FpTjRYVFQxUlpmSnZiUEVYcHkwK1ZrbGtLZ1FLQmdRRDJQRGMrR3NId001ek9mNTNyCmFkVUdlV09YQllOam5pS1hCZDZialhxWWdHMGhBWlhwVTd5SFhFVnFDSXpiQTlGdndNS3BiOXAzNGE5N1oyaTUKK3JkRTU3ZzVaT1ZhazBQc2RnRDlDUW9YTld1ZU54RFJFNU45dmhjTEtoN1BlNXBLYU1BK1lrN1VhZ1N4T1dHWQpLMmhBeHRrZTdlUWlyQlNER24vL2RDU3F1UUtCZ1FEcFRqZ0E3aUd4Z24rektTcWFEWXAycm1Td2FDZHFqY3hxCmsvSTI5RW1ma2RvamdKYjN1cGxZR1lEejVUUVBvQzhHMFBYZVdQSEQ0YjdVcStkckYxQkw1Z2dYM2pjQVRrN0cKV3B3Z25UMS9zT0pXVDNEemJEUkNTV04rdUYrMjNYS2VtNGx3YmNYS0NDOWpTcmx0dWUyZ3g1U0tNa0NTamxoQgowNjVLTWhqRXh3S0JnUUROQmNaWmg1NERpblg5Mm5SN0YxdXdVRktENUt0SnZ0bStOYnpzZUJpajhncnJlSTZDCkFKN3hkZnEyRnZoeFEvU1d3RUZWSXpVY3JHV1lzcm1ZWVJGSDVraVdRVlJXM2xlb0Ezay9OcytZRTNyUCtibWUKM0ZYcVZPU0svejg0TXdwOCtrdFhwak5NMmhtZUZ0RVVDdEI3WHhaWmttcHFGQzNnRzZpSDR3VEV3UUtCZ0dUNApPQjZXOExnTkhVMGhkTkdGS0xhaVZPdFB1RGRTTlBTdklMV04xY3NjYVViU0lRUUhtdFBZL2NrUUdnN2xLVlVPCjNFbWxQc1NpajE4bElwdGpWSm4wYk80L2VwaEVTNjFtaTRsRjQ5YSthOFlreldKY0l1WEpNeWtsakM3cytlMFEKclZPZC9tcW9Uakh2cGY2SjZBQ2NQM25yczZ4NXRGS1ExUzVCTGgwREFvR0JBT2FxaHdYeWYvQkNNTjBYaVdtLwpKbGZRM0ZFeThJRVE2alZPaXZ3NFlENlVkZ2FPWW1EdGtaakYwUjNGa2FQRmJqalhhRHY5N0JyaW11THJieWZpCjRrY3BzMDJESSthR3RURE5uclRsNk5OazdJY0NSc2w4UTZqcVdmVEJrM3pMdTM2VXpWN1dQYmx1MG1SY1dkeEMKSTdudjh1UGkyVXZmMkNlNTdNclNWL1lQCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K')
  allow(lumberjack_data_bag).to receive(:[]).with('certificate').and_return('LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURwVENDQW8yZ0F3SUJBZ0lKQU0xQm5BenhxWWdmTUEwR0NTcUdTSWIzRFFFQkN3VUFNR2t4Q3pBSkJnTlYKQkFZVEFsVlRNUXN3Q1FZRFZRUUlEQUpVV0RFVU1CSUdBMVVFQnd3TFUyRnVJRUZ1ZEc5dWFXOHhFakFRQmdOVgpCQW9NQ1ZKaFkydHpjR0ZqWlRFUE1BMEdBMVVFQ3d3R1JHVjJUM0J6TVJJd0VBWURWUVFEREFsRlRFc2djM1JoClkyc3dIaGNOTVRRd09URTRNVGt5T1RJeldoY05NVGN3TmpFME1Ua3lPVEl6V2pCcE1Rc3dDUVlEVlFRR0V3SlYKVXpFTE1Ba0dBMVVFQ0F3Q1ZGZ3hGREFTQmdOVkJBY01DMU5oYmlCQmJuUnZibWx2TVJJd0VBWURWUVFLREFsUwpZV05yYzNCaFkyVXhEekFOQmdOVkJBc01Ca1JsZGs5d2N6RVNNQkFHQTFVRUF3d0pSVXhMSUhOMFlXTnJNSUlCCklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUE0R2dLZm14b3BHeVplUFRUZCtTaE8yZ1EKUm12aUsrMjZscWlUN3RVN1ZFV2JSSUdyRFFpV1BLRERzS1N1ZE1VLytqMzkzaXZyWmFEeEtMUzViSDBMU1Z4NwpadzBVM3dNaEttK1BRbDJaK0JONWhqN1dZd3k0MUVGdjVJNy9jWU1lWk8vQkxtMW5SRWJEclJLdHYrWXpCbHZnCm81OWxFbU43NEN2VmhtaUx3eFVBV3BxK0YyZW04c3RnSW5jZEM2S1BBYUFMT2U1SU1yT3Y2U25DanhTZDVQWWgKWGpEV1lJVFZJdG94Z09jMWRpVU1PZmUxOCtaZUdSeGNicXZ3OXkwdzJYSnFYWndvdTcrREZ3ZTN4T2JKZWVwSAo2VEk5bzdBeGJrMWpJanNOR2hSb0FmSnlTSWNsYW5rcGtTajE1bWNDVG5qNnlpdTg1OEJHV1RqQmZvNVp6d0lECkFRQUJvMUF3VGpBZEJnTlZIUTRFRmdRVXVwclZZd2Q3aG8zaUxCWWZudkVaUUw3Wlo4b3dId1lEVlIwakJCZ3cKRm9BVXVwclZZd2Q3aG8zaUxCWWZudkVaUUw3Wlo4b3dEQVlEVlIwVEJBVXdBd0VCL3pBTkJna3Foa2lHOXcwQgpBUXNGQUFPQ0FRRUFzRzJEYXFOREt3T1VPbWJYRnhWeWlEVWJFaG9uTUkrRXgyM3Brc2FqUnNMdVJBQVpiSDY1CkVHQy9Rb1dkVE5BSkVFSzdVeVRmMVk0VENHU0Z5KzZ1TDRMRWNEREtlTWRJaEJIcEdXM2FocnVwcW8vNDR2OEUKTm1iTmcvWklkUXBZYjJZcHVlcjdPRDVGaGI5aVFxc2tuRzRJcTR5dC9zR3hLSEdmNktQY3c1dkJxK3BWTFVidwpSczczVDhINU5XKzduUUNZS1RSVU92dGY0SkgwbXEyMW9Yd0VvK2JGUHkrNVhPQitqVExtVnN4WWhnU1R6Z3h1CjhqTUpiNnhzSzJPVUdpcUl3a0ZsREdqVmluN3Rlb2JReUpzQklaaEptSXVkT0FIdU9jQ0VrR3c2SUJuaGpoUmcKaEg2djg0V0lIQ2tZeVZlb2dRWGkwWnRtbEt4NVk4SDh1QT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K')
  allow(lumberjack_data_bag).to receive(:to_hash).and_return({})
  # rubocop:enable Metrics/LineLength

  # stub /etc/hosts to be missing anything we might look for
  etc_hosts = double('/etc/hosts')
  allow(File).to receive(:exists?).and_call_original
  allow(File).to receive(:exists?).with('/etc/hosts').and_return(true)
  allow(File).to receive(:open).and_call_original
  allow(File).to receive(:open).with('/etc/hosts', 'r+').and_return(etc_hosts)
  allow(etc_hosts).to receive(:lines).and_return(['# ignore this line'])

  # misc commands
  stub_command('which nginx').and_return('/usr/sbin/nginx')
  stub_command('which sudo').and_return('rack')
  stub_command("curl -sI http://eslocal:9200/_snapshot/elkstack | grep -q \"404 Not Found\"").and_return(0)
  stub_command("rpm -qa | grep -q '^runit'").and_return(1)
  stub_command("/usr/local/go/bin/go version | grep \"go1.3 \"").and_return(0)
end

at_exit { ChefSpec::Coverage.report! }
