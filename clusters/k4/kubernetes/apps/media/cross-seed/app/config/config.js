function fetchIndexers(baseUrl, apiKey, tag) {
    const buffer = require('child_process').execSync(`curl -fsSL "${baseUrl}/api/v1/tag/detail?apikey=${apiKey}"`);
    const response = JSON.parse(buffer.toString('utf8'));
    const indexerIds = response.filter(t => t.label === tag)[0]?.indexerIds ?? [];
    const indexers = indexerIds.map(i => `${baseUrl}/${i}/api?apikey=${apiKey}`);
    console.log(`Loaded ${indexers.length} indexers from Prowlarr`);
    return indexers;
}

module.exports = {
    action: "inject",
    apiKey: process.env.CROSSSEED_APIKEY,
    dataDirs: ["/var/mnt/hdd1/downloaded"],
    excludeRecentSearch: "1 week",
    excludeOlder: "2 weeks",
    linkCategory: "cross-seed",
    linkDirs: ["/var/mnt/hdd1/cross-seed"],
    linkType: "hardlink",
    matchMode: "partial",
    port: Number(process.env.CROSSSEED_PORT),
    rssCadence: null, // autobrr feeds him with torrents
    searchCadence: "1 day",
    skipRecheck: true,
    // radarr: [`http://radarr.media.svc.cluster.local:7878/?apikey=${process.env.RADARR__AUTH__APIKEY}`],
    sonarr: [`https://sonarr-anime.${process.env.SECRET_DOMAIN}/?apikey=${process.env.SONARR_ANIME__AUTH__APIKEY}`],
    torrentClients: [`qbittorrent:${process.env.QBITTORRENT_PROXY_URL}`],
    torznab: fetchIndexers(`https://prowlarr.${process.env.SECRET_DOMAIN}`, process.env.PROWLARR__AUTH__APIKEY, "cross-seed"),
    useClientTorrents: true
};