#
# Copyright 2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "rust"
default_version "2015-10-03"

license "Apache-2.0"
license_file "COPYRIGHT"

# Nightly releases use a slighty different URL and TARBALL naming convention
if version =~ /\d{4}-\d{2}-\d{2}/
  relative_path_template = "rust-nightly-x86_64-%{host_triple}"
  url_template = "https://static.rust-lang.org/dist/#{version}/rust-nightly-x86_64-%{host_triple}.tar.gz"
else
  relative_path_template = "rust-#{version}-x86_64-${host_triple}"
  url_template = "https://static.rust-lang.org/dist/rust-#{version}-x86_64-%{host_triple}.tar.gz"
end

if windows?
  host_triple = "pc-windows-gnu"

  version "2015-10-03" do
    source md5: "25ae6f2624a02fde12d515779a238658",
           url: url_template % { host_triple: host_triple }
  end
elsif mac_os_x?
  host_triple = "apple-darwin"

  version "2015-10-03" do
    source md5: "0485cb9902a3b3c563c6c6e20b311419",
           url: url_template % { host_triple: host_triple }
  end
else
  host_triple = "unknown-linux-gnu"

  version "2015-10-03" do
    source md5: "eff35d920b30f191b659075a563197a6",
           url: url_template % { host_triple: host_triple }
  end
end

relative_path relative_path_template % { host_triple: host_triple }

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "sh install.sh" \
          " --prefix=#{install_dir}/embedded" \
          " --components=rustc,cargo" \
          " --verbose", env: env
end