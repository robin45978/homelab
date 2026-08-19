#!/bin/bash
##      Cloudflare Analytics zu InfluxDB 2.x für Grafana
##      Quelle: https://github.com/robin45978/homelab/scripts/cloudflare/

# Konfiguration für InfluxDB 2.x
InfluxDBURL=""
InfluxDBOrg=""
InfluxDBBucket=""
InfluxDBToken=""

# Cloudflare API-Konfiguration
cloudflareapikey=""
cloudflarezone=""
cloudflareemail=""

# Zeitbereich: letzte 7 Tage
back_seconds=60*60*24*7
end_epoch=$(date +'%s')
let start_epoch=$end_epoch-$back_seconds
start_date=$(date --date="@$start_epoch" +'%Y-%m-%d')
end_date=$(date --date="@$end_epoch" +'%Y-%m-%d')

# GraphQL Payload
PAYLOAD='{ "query":
  "query {
  viewer {
    zones(filter: {zoneTag: $zoneTag}) {
      httpRequests1dGroups(limit:7, filter: $filter,)   {
        dimensions { date }
        sum {
          browserMap { pageViews uaBrowserFamily }
          bytes
          cachedBytes
          cachedRequests
          contentTypeMap { bytes requests edgeResponseContentTypeName }
          countryMap { bytes requests threats clientCountryName }
          encryptedBytes
          encryptedRequests
          ipClassMap { requests ipType }
          pageViews
          requests
          responseStatusMap { requests edgeResponseStatus }
          threats
          threatPathingMap { requests threatPathingName }
        }
        uniq { uniques }
      }
    }
  }
}",'

PAYLOAD="$PAYLOAD

  \"variables\": {
    \"zoneTag\": \"$cloudflarezone\",
    \"filter\": {
      \"date_geq\": \"$start_date\",
      \"date_leq\": \"$end_date\"
    }
  }
}"

# Anfrage an Cloudflare GraphQL
cloudflareUrl=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $cloudflareapikey" \
  --data "$(echo $PAYLOAD)" \
  https://api.cloudflare.com/client/v4/graphql/ \
  2>&1 --silent)

echo "Cloudflare API Response:"
echo "$cloudflareUrl" | jq .

declare -i arraydays=0
for requests in $(echo "$cloudflareUrl" | jq -r '.data.viewer.zones[0].httpRequests1dGroups[].sum.requests'); do
    cfRequestsAll=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.requests")
    if [[ $cfRequestsAll == "null" ]]; then break; fi

    cfRequestsCached=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.cachedRequests")
    cfRequestsUncached=$(echo "$cfRequestsAll - $cfRequestsCached" | bc)
    cfBandwidthAll=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.bytes")
    cfBandwidthCached=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.cachedBytes")
    cfBandwidthUncached=$(echo "$cfBandwidthAll - $cfBandwidthCached" | bc)
    cfThreatsAll=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.threats")
    cfPageviewsAll=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.pageViews")
    cfUniquesAll=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].uniq.uniques")
    date=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].dimensions.date")
    cfTimeStamp=$(date -d "$date" '+%s')

    # 📤 Haupt-Datensatz an InfluxDB
    curl -s -XPOST "$InfluxDBURL/api/v2/write?org=$InfluxDBOrg&bucket=$InfluxDBBucket&precision=s" \
      --header "Authorization: Token $InfluxDBToken" \
      --data-binary "cloudflare_analytics,cfZone=$cloudflarezone cfRequestsAll=$cfRequestsAll,cfRequestsCached=$cfRequestsCached,cfRequestsUncached=$cfRequestsUncached,cfBandwidthAll=$cfBandwidthAll,cfBandwidthCached=$cfBandwidthCached,cfBandwidthUncached=$cfBandwidthUncached,cfThreatsAll=$cfThreatsAll,cfPageviewsAll=$cfPageviewsAll,cfUniquesAll=$cfUniquesAll $cfTimeStamp"
echo "InfluxDB response:"
echo "$response"

    # 📤 Länder-Daten pro Tag
    declare -i arraycountry=0
    for requests in $(echo "$cloudflareUrl" | jq -r '.data.viewer.zones[0].httpRequests1dGroups[].sum.countryMap[]'); do
        cfRequestsCC=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.countryMap[$arraycountry].clientCountryName")
        if [[ $cfRequestsCC == "null" ]]; then break; fi
        cfRequests=$(echo "$cloudflareUrl" | jq -r ".data.viewer.zones[0].httpRequests1dGroups[$arraydays].sum.countryMap[$arraycountry].requests // \"0\"")

        curl -s -XPOST "$InfluxDBURL/api/v2/write?org=$InfluxDBOrg&bucket=$InfluxDBBucket&precision=s" \
          --header "Authorization: Token $InfluxDBToken" \
          --data-binary "cloudflare_analytics_country,country=$cfRequestsCC visits=$cfRequests $cfTimeStamp"

        arraycountry=$arraycountry+1
    done
    arraydays=$arraydays+1
done
