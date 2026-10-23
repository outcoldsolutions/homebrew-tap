cask "collectorformacos" do
  version "26.10.1"
  # At a release: the version above, and the sha256 the release draft's SHA256SUMS gives
  # collectorformacos-<version>.pkg (the signed, notarized package publish-packages.yml uploads to
  # the url below; a local build is unsigned and differs).
  sha256 "183fa13f0fef031e002a6d29988a6200585a7838f709b1c7f12eeb07d0614dc8"

  url "https://packages.outcold.solutions/downloads/collectorformacos/#{version}/collectorformacos-#{version}.pkg",
      verified: "packages.outcold.solutions/downloads/collectorformacos/"
  name "Monitoring macOS - Collectord"
  desc "Forwards metrics, logs and events to Splunk"
  homepage "https://www.outcoldsolutions.com/"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  pkg "collectorformacos-#{version}.pkg"

  uninstall launchctl: "com.outcoldsolutions.collectord",
            pkgutil:   "com.outcoldsolutions.collectorformacos",
            delete:    [
              "/Library/LaunchDaemons/com.outcoldsolutions.collectord.plist",
              "/opt/collectorformacos/bin",
              "/private/etc/newsyslog.d/collectorformacos.conf",
            ]

  # Deleted, not trashed: the configuration holds the HEC token, and a trashed copy would land in
  # the Trash of whoever ran the zap.
  zap delete: [
    "/Library/Logs/collectorformacos",
    "/opt/collectorformacos",
  ]

  caveats <<~EOS
    Set the Splunk HEC URL and token (allowed to write the macos_metrics metrics index, or
    the one you name there) and accept the licence in
      /opt/collectorformacos/etc/002-user.conf
    (or with a configuration profile), then check the collector with
      sudo /opt/collectorformacos/bin/collectord verify
  EOS
end
