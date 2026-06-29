

# Project Title

Are Muslim-Friendly Tourism Ecosystems Emerging in Taiwan's Major Cities?

A Spatial Comparison of Taipei, Taichung, and Kaohsiung


## Project Description

Abstract

This thesis investigates whether Muslim-friendly tourism ecosystems are emerging in Taiwan's three major urban destinations: Taipei, Taichung, and Kaohsiung. Rather than evaluating Muslim-friendly tourism readiness only by the total number of halal-certified facilities, the study examines whether hotels, restaurants, tourist attractions, prayer facilities, and mass transit access are spatially arranged in ways that can support actual visitor movement. The analysis uses official halal-certified hotel and restaurant records, tourist attraction data, prayer room and mosque locations, MRT station coordinates, and district boundary data. All spatial layers are projected to TWD97 / EPSG:3826 and analysed through four stages: exploratory spatial data analysis, distance-based accessibility measurement, district-level concentration analysis, and ecosystem qualification using 1 km and 500 m thresholds.
The study therefore introduces a spatial-contingency perspective: Muslim-friendly destination readiness is evaluated not as a static inventory of certified assets, but as a functional relationship among accommodation, dining, attraction, prayer, and transit nodes. This approach is especially relevant for non-OIC destinations, where Muslim-friendly services are not always embedded in the everyday urban service environment and where visitors may depend strongly on public transport, pre-planned routes, and trustworthy digital information. The thesis also recognises a social-information dimension: nearby facilities become more useful when they are visible through official lists, map platforms, peer reviews, and community recommendations.
The findings show that Taipei has the most complete Muslim-friendly tourism ecosystem, with 82.7 percent of halal-certified hotels meeting the 1 km ecosystem threshold. Kaohsiung also performs strongly, with 67.7 percent of hotels qualifying at 1 km, but its ecosystem is concentrated around central districts and transit corridors. Taichung has the weakest and thinnest ecosystem in the sample, with 57.1 percent of hotels qualifying at 1 km and only seven accommodation records included in the analysis. Global Moran's I results do not show statistically significant district-scale clustering, but KDE and MRT-overlay maps reveal a clearer substantive pattern: halal-certified hotels and restaurants tend to align with accessible urban corridors, especially in Taipei and Kaohsiung. The study concludes that Muslim-friendly tourism readiness should be understood as an accessibility ecosystem rather than a facility-count ranking.
## Getting Started

1. Introduction

1.1 Background

Muslim-friendly tourism has become an increasingly important part of international destination competitiveness. For Muslim travelers, destination readiness is shaped not only by the presence of halal food, accommodation, and prayer facilities, but also by whether these resources are located close enough to hotels, attractions, and transport corridors to be usable during a real trip. A city may have many certified facilities in total, yet still create friction for visitors if those facilities are spatially separated from the places where tourists sleep, eat, pray, and move.
Taiwan has actively promoted itself as a Muslim-friendly destination and has performed strongly in international Muslim travel rankings. However, a ranking based mainly on the quantity of certified facilities cannot fully answer whether those facilities form practical tourism ecosystems. This thesis therefore shifts the analytical lens from counting facilities to mapping their spatial relationships.
1.2 Research Problem

The central problem is that Muslim-friendly tourism infrastructure is often discussed as a national inventory rather than a spatial system. For a traveler, a halal restaurant five kilometers away from the hotel is not equivalent to one located within walking distance or near a transit line. Similarly, a tourist attraction surrounded by restaurants that are not halal-certified may remain less accessible to Muslim visitors even when the city has many certified restaurants elsewhere.
This study asks whether halal-certified accommodation, halal dining, tourist attractions, prayer facilities, and MRT access are spatially connected in Taipei, Taichung, and Kaohsiung. The practical contribution is to identify where Muslim-friendly ecosystems already exist and where targeted certification or infrastructure development could close gaps.
The research problem is therefore not simply a shortage of facilities. It is a problem of spatial organization. A city may report a strong number of certified assets, but if those assets are distributed in ways that force long detours between hotels, food, attractions, and prayer spaces, the visitor experience remains fragmented. This thesis evaluates that fragmentation directly.
1.3 Research Questions

The main research question is:
What spatial relationships exist between halal-certified hotels, halal restaurants, tourist attractions, prayer facilities, and MRT access in Taipei, Taichung, and Kaohsiung, and do these relationships indicate the emergence of Muslim-friendly tourism ecosystems at the city level?
The study addresses three sub-questions:
● RQ1: Are Muslim-friendly tourism resources spatially concentrated or randomly distributed within each city?
● RQ2: How accessible are halal restaurants, tourist attractions, and prayer facilities from halal-certified hotels?
● RQ3: Which cities and districts meet the spatial threshold to qualify as Muslim-friendly tourism ecosystems?
1.4 Operational Definition

A hotel location is treated as ecosystem-qualifying if it has at least one halal food source and at least one tourist attraction within a 1 km radius. A stricter 500 m threshold is also tested. Facilities labelled as Hotel & Restaurant are counted as both accommodation and halal food infrastructure, but a hotel-restaurant is not allowed to count itself as the nearest restaurant or as its own restaurant source. This rule reflects the practical reality that a traveler may stay in one certified hotel and eat at another certified hotel restaurant, while avoiding artificial zero-distance results.
This definition intentionally treats an ecosystem as a spatial relationship rather than as a branding label. A certified hotel by itself does not create a tourism ecosystem; it becomes part of one when dining, attraction access, prayer support, and transport connectivity are close enough to reduce friction in the visitor journey. The 1 km threshold is used as a practical urban accessibility benchmark, while the 500 m threshold approximates a stricter walkable environment. Comparing both thresholds allows the analysis to distinguish between general proximity and genuinely compact tourism support.
In this paper, an accommodation that meets the threshold is described as a qualifying Muslim-friendly tourism ecosystem node. The term node is used because the unit of analysis is not an entire city or district, but the hotel-centered urban envelope within which a tourist's daily activities can be supported.

2. Literature Review and Conceptual Framework

2.1 Muslim-Friendly Tourism as a Spatial System

Research on Muslim-friendly tourism commonly emphasizes halal food availability, prayer facilities, accommodation services, safety, cultural sensitivity, and destination image. These attributes are important, but many destination assessments treat them as inventories: a city is considered more prepared when it has more certified restaurants, more Muslim-friendly hotels, or more prayer rooms. This study builds on that literature while adding a spatial argument. Muslim-friendly tourism readiness depends not only on whether facilities exist, but also on whether they are arranged in ways that support the everyday sequence of tourist activities.
For Muslim travelers, the tourism experience is organized through linked needs. Accommodation, food, attractions, prayer space, and mobility are not separate categories in practice. A visitor may begin at a hotel, travel to an attraction, search for halal dining, and need a prayer space within the same half-day itinerary. If these resources are geographically fragmented, the destination may appear Muslim-friendly in aggregate but remain inconvenient on the ground. This is why the present study conceptualizes Muslim-friendly tourism as an urban ecosystem formed through spatial complementarity.
This issue is particularly important in non-OIC destinations such as Taiwan, where halal food systems and prayer spaces are not always naturally integrated into the wider hospitality landscape. In these settings, Muslim-friendly tourism development depends on institutional adaptation, certification visibility, and careful placement of services in visitor-accessible areas.
Beyond physical location, Muslim-friendly tourism also has a social dimension. Visitors often rely on peer reviews, community recommendations, social media posts, and halal-oriented digital platforms to decide whether a restaurant, hotel, or prayer space is trustworthy. Spatial proximity reduces travel friction, but social visibility reduces uncertainty. For this reason, an ecosystem is stronger when certified facilities are not only nearby, but also recognisable, reviewed, and communicated through channels that Muslim travelers actually use.
2.2 Accessibility, Proximity, and Visitor Friction

Accessibility is central to tourism geography because tourists have limited time, imperfect local knowledge, and strong sensitivity to route convenience. In this thesis, distance is interpreted as a proxy for visitor friction. Shorter hotel-to-restaurant distances imply easier dining access, while shorter hotel-to-attraction distances suggest stronger integration between accommodation and sightseeing. Prayer facility distance is interpreted as a supplementary but meaningful comfort indicator. Although Euclidean distance cannot fully capture actual walking routes or transit transfers, it provides a consistent basis for comparing the three cities.
The use of both 1 km and 500 m thresholds reflects two levels of accessibility. A 1 km radius captures a reasonable nearby urban support zone, especially when transit and taxis are available. A 500 m radius is more demanding and closer to a comfortable walking environment. The contrast between the two thresholds is analytically useful: if a city performs well at 1 km but poorly at 500 m, its ecosystem may be present but spatially loose. If it performs well at both thresholds, its Muslim-friendly infrastructure is more compact and easier to use.
2.3 From Clustering to Corridor-Based Ecosystems

Spatial clustering methods are useful for identifying whether similar values gather together. However, tourism ecosystems do not always appear as large contiguous clusters at the district scale. They may instead form around corridors, nodes, and central activity zones. In cities with extensive rapid transit systems, hotels and restaurants often follow accessibility corridors because these areas concentrate visitors, workers, retail activity, and land-use intensity. Therefore, a Muslim-friendly tourism ecosystem may be better understood as a corridor-based accessibility pattern than as a simple district-level hot spot.
This distinction is important for interpreting the Stage 3 results. The Global Moran's I test asks whether high-value districts are adjacent to other high-value districts. The KDE and MRT-overlay maps ask a different question: whether facilities align with the places where visitors are likely to move. In this thesis, the statistical and visual methods are treated as complementary rather than competing. Moran's I provides a district-scale autocorrelation check, while KDE and MRT overlay reveal finer-grained spatial organization.
2.4 Conceptual Model

The conceptual model links four ideas. First, facility availability provides the basic supply of Muslim-friendly tourism resources. Second, spatial proximity determines whether these resources are practically usable from hotel locations. Third, transit accessibility shapes how these resources connect to urban tourist movement. Fourth, social visibility shapes whether visitors can identify and trust the resources that are physically nearby. A city can therefore be classified not only by how many facilities it has, but by whether those facilities form overlapping hotel-food-attraction-prayer-transit environments that are visible and legible to Muslim travelers.
The empirical expectation is that Taipei will show the strongest ecosystem because it has the largest urban tourism market and the densest MRT network. Kaohsiung is expected to show an emerging but more corridor-based ecosystem. Taichung is expected to show a weaker ecosystem due to fewer halal-certified accommodation records and a smaller MRT network in the study area. The social-information layer is not used to calculate ecosystem qualification, but it is used in the discussion to explain how visitors discover, evaluate, and share the spatial resources identified by the GIS analysis.

## File Structure
3. Data and Study Area

3.1 Study Area

The study compares Taipei, Taichung, and Kaohsiung. Taipei represents Taiwan's capital city and the most mature international gateway. Taichung represents an intermediate urban tourism case with a smaller MRT system and fewer halal-certified accommodations in the final dataset. Kaohsiung represents a southern metropolitan destination with strong tourism potential and a visible transit corridor in the urban core.
3.2 Data Sources and Cleaning

The analysis uses four spatial data groups: halal-certified hotels and restaurants, tourist attractions, prayer rooms and mosques, and MRT stations. Administrative district boundaries are used to aggregate facility counts and support district-level comparison. The updated halal-certified facility workbook was used as the primary Dataset 1 source. Duplicate records were removed using facility name, type, city, district, latitude, and longitude. All point datasets were filtered to the original urban core districts used in the study and projected to TWD97 / EPSG:3826 so that distance calculations are measured in meters.
The halal hotel and restaurant dataset was derived from Taiwan Tourism Administration Muslim-friendly dining and accommodation records. Tourist attractions were drawn from Taiwan Tourism Administration open data. Prayer facilities and mosques were compiled from the Muslim-friendly facility list and mosque records, while MRT station coordinates were used to represent fixed urban mobility infrastructure. These sources were harmonized into a common city and district structure before spatial analysis.
The main official source for halal-certified dining and accommodation was the Taiwan Tourism Administration's Muslim-friendly Environment: Dining & Accommodation listing (https://eng.taiwan.net.tw/m1.aspx?sNo=0020323). Halal Formosa (https://halalformosa.com) was also used as a contextual halal information source for Taiwan's halal facility environment. The thesis treats the Tourism Administration listing as the primary official dataset and Halal Formosa as a supplementary reference for the wider Muslim-friendly service landscape.
The final cleaned data contain 95 halal facilities in Taipei, 27 in Taichung, and 36 in Kaohsiung when hotels, restaurants, and hotel-restaurant records are counted as Dataset 1 facilities. Taipei also has the largest number of tourist attractions and prayer facilities in the study area, while Kaohsiung has a stronger tourist attraction base than Taichung but fewer prayer facilities.
City
Hotels
Hotel & Restaurant
Restaurants
Attractions
Prayer Rooms
Mosques
MRT Stations
Taipei
43
9
43
80
30
4
73
Taichung
3
4
20
15
3
2
14
Kaohsiung
23
8
5
41
2
2
28
 
Table 1. Cleaned facility counts by city after filtering to the study districts.

4. Methodology

4.1 Analytical Design

The research design follows four sequential stages. Stage 1 maps the spatial distribution of facilities as a descriptive baseline. Stage 2 calculates nearest-neighbor distances from each halal-certified hotel to the nearest halal restaurant, attraction, and prayer facility. Stage 3 evaluates spatial concentration using district counts, Kernel Density Estimation (KDE), MRT-overlay mapping, and Global Moran's I. Stage 4 applies the ecosystem definition by counting restaurants, attractions, and prayer facilities within 1 km and 500 m buffers around each hotel.
4.2 Stage 1: Exploratory Spatial Data Analysis

Stage 1 uses multi-layer point maps to identify where facilities are located before formal statistics are applied. Hotels, restaurants, hotel-restaurant records, attractions, prayer facilities, and MRT stations are plotted against district boundaries. This stage is descriptive but important because the research question is spatial: the location of facilities matters as much as their count.
4.3 Stage 2: Distance-Based Accessibility

Stage 2 calculates the distance from each halal-certified hotel to the nearest halal food source, tourist attraction, and prayer facility. Hotels and Hotel & Restaurant records are treated as accommodation; Restaurant and Hotel & Restaurant records are treated as halal food sources. Same-facility matches are excluded when a Hotel & Restaurant record appears in both layers. This prevents the nearest restaurant distance from becoming zero simply because the hotel contains a restaurant.
4.4 Stage 3: Spatial Concentration and MRT Overlay

Stage 3 uses two forms of spatial concentration analysis. First, district-level counts are used to calculate Muslim-friendly support intensity, defined as halal facilities plus prayer facilities. Tourist attractions are shown separately as contextual demand-side locations rather than being included in the support score. Second, KDE is calculated from tourist attractions and prayer facilities, while grouped halal facility bubbles are overlaid at the actual locations of halal hotels and restaurants. A second version overlays MRT station proximity lines to examine whether halal infrastructure aligns with public transport corridors.
The KDE surface uses a Gaussian kernel with an 800 m bandwidth. This bandwidth is wide enough to show neighborhood-scale intensity while still preserving the local corridor patterns visible in the three study cities. For the district-level autocorrelation check, Global Moran's I is calculated using queen contiguity weights, meaning that districts are treated as neighbors when they share a border or vertex.
Global Moran's I is retained as a statistical check. In this study, Moran's I tests whether similar district values are adjacent to one another. Because each city has only 8 to 12 districts, the test is interpreted cautiously: a non-significant result does not mean there is no meaningful tourism pattern, only that district-level values are not consistently autocorrelated across neighboring districts.
4.5 Stage 4: Ecosystem Qualification

Stage 4 identifies ecosystem-qualifying hotels. A hotel qualifies at the 1 km threshold if at least one halal food source and at least one tourist attraction are within 1 km. The same rule is repeated at 500 m as a stricter walkability threshold. Prayer facilities are reported as supplementary support because they are important for Muslim traveler comfort but are much less numerous than restaurants and attractions in the dataset. Social visibility, such as whether facilities appear in official tourism lists, halal apps, online maps, or peer-review platforms, is not included in the distance threshold because comparable platform data were not available. It is therefore discussed as an implementation issue that can strengthen or weaken the practical value of spatial proximity.

## Analysis

[Describe your analysis methods and include any visualizations or graphics that you used to present your findings. Explain the insights that you gained from your analysis and how they relate to your research question or problem statement.]

## Results

5. Results

5.1 Stage 1: Spatial Distribution of Facilities

The Stage 1 maps show substantial differences in facility density across the three cities. Taipei has the largest and most layered network, with many halal hotels, restaurants, attractions, prayer facilities, and MRT stations located in the central city. Kaohsiung has fewer halal restaurants than Taipei but shows a visible concentration of halal hotels and hotel-restaurant records around the urban transit corridor. Taichung has fewer hotels in the final accommodation layer, and its facilities are more dispersed across the central districts.

Figure 1. Stage 1 exploratory map of Muslim-friendly tourism resources in Taipei, Taichung, and Kaohsiung.

5.2 Stage 2: Distance-Based Accessibility

Stage 2 shows that Taipei provides the strongest hotel-to-restaurant accessibility. The median distance from a halal-certified hotel to the nearest halal food source is 419 m in Taipei, compared with 634 m in Kaohsiung and 702 m in Taichung. The 1 km result strengthens this contrast: 88 percent of Taipei hotels have a halal food source within 1 km, compared with 68 percent in Kaohsiung and 57 percent in Taichung.
Accessibility to tourist attractions is also strongest in Taipei and Kaohsiung. In Taipei, the median hotel-to-attraction distance is 334 m, and 90 percent of hotels have an attraction within 1 km. Kaohsiung has a median of 419 m and the same 90 percent within 1 km. Taichung is weaker, with a median hotel-to-attraction distance of 796 m and only 57 percent of hotels within 1 km of an attraction.
Prayer facility accessibility is the weakest dimension in all three cities. Taipei performs best, with a median distance of 832 m and 60 percent of hotels within 1 km of a prayer facility. Kaohsiung's median distance is 1,500 m, and only 32 percent of hotels are within 1 km. Taichung has the weakest prayer accessibility, with a median distance of 2,076 m and only 14 percent of hotels within 1 km.
These distance results suggest that the three cities differ not simply in quantity but in the type of spatial friction Muslim travelers may experience. Taipei's main advantage is consistency: most hotels are close to both halal food and attractions, so the probability of a visitor finding nearby support is high across many hotel locations. Kaohsiung's result is more uneven. Many hotels are close to attractions, but restaurant distances are longer and prayer facilities are less available, creating a partial ecosystem. Taichung's distances indicate a thinner network, where some hotels are well placed but others are relatively isolated from the halal food and attraction layers.
The difference between median and mean restaurant distance is also informative. Kaohsiung and Taichung have mean restaurant distances above 1 km, even though their medians are below 1 km. This indicates the presence of outlying hotels that are much farther from halal food sources. Taipei's mean restaurant distance remains below 500 m, showing that its accessibility advantage is not only produced by a few central hotels but is more broadly distributed across the hotel sample.
City
Hotels
Restaurant median (m)
Restaurant <=1 km
Attraction median (m)
Attraction <=1 km
Prayer median (m)
Prayer <=1 km
Kaohsiung
31
634
68%
419
90%
1500
32%
Taichung
7
702
57%
796
57%
2076
14%
Taipei
52
419
88%
334
90%
832
60%
 
Table 2. Stage 2 hotel-based nearest-distance results.


Figure 2. Distribution of nearest facility distances by city.

5.3 Stage 3: District Intensity, KDE, and MRT Alignment

The district support-intensity results show that Taipei has the strongest concentration of Muslim-friendly support infrastructure. Zhongzheng is the highest-scoring district in the full study, with 15 halal facilities, 6 prayer facilities, and a support intensity score of 21. Zhongshan, Da'an, Beitou, Songshan, Shilin, and Xinyi also show strong support scores. In Kaohsiung, Xinxing is the most important district, with 12 halal facilities. In Taichung, West District is the leading support district, followed by Nantun and North.
These district results show different urban forms. Taipei's high-support districts form a multi-node central system, including the traditional central station area, commercial districts, and northern hot spring and visitor zones. Kaohsiung's support is more concentrated, with Xinxing functioning as a central anchor and Yancheng, Lingya, Sanmin, and Zuoying providing secondary support. Taichung's support is concentrated in West District and nearby central districts, but the overall number of qualifying hotels remains small.
City
Top district
Halal
Attractions
Prayer
Support intensity
Taipei
Zhongzheng
15
13
6
21
Taipei
Zhongshan
15
8
0
15
Taipei
Da'an
12
3
2
14
Taichung
West
8
3
0
8
Taichung
Nantun
4
1
2
6
Taichung
North
4
3
1
5
Kaohsiung
Xinxing
12
2
0
12
Kaohsiung
Yancheng
6
3
0
6
Kaohsiung
Lingya
3
6
2
5
 
Table 3. Highest support-intensity districts by city.

The Global Moran's I results are not statistically significant for the support-intensity variable in any city. Taipei has Moran's I = -0.153 (p = 0.639), Taichung has Moran's I = -0.086 (p = 0.369), and Kaohsiung has Moran's I = 0.008 (p = 0.258). This means that, at the district scale, high-support districts are not consistently surrounded by other high-support districts. The result should not be interpreted as evidence that the maps have no pattern. Instead, it means the pattern is better described as localized corridor alignment and central-place concentration than as broad district-to-district spatial autocorrelation.
City
Moran's I
z-score
p-value
Result
Taipei
-0.1526
-0.355
0.6386
Random
Taichung
-0.0858
0.335
0.369
Random
Kaohsiung
0.0081
0.649
0.2583
Random
 
Table 4. Global Moran's I for Muslim-friendly support intensity.

The KDE and MRT-overlay maps provide the clearest Stage 3 interpretation. The KDE surface is based on tourist attractions and prayer facilities, while brown bubbles represent grouped halal facilities at their actual locations. The added MRT overlay shows that many halal hotels and restaurants are positioned along or near transit-accessible corridors. This pattern is especially clear in Taipei, where halal facilities cluster around central MRT-connected districts, and in Kaohsiung, where facilities align with the main urban transit corridor. Taichung shows a weaker relationship because the MRT network and the halal accommodation layer are both smaller.
The MRT overlay changes the interpretation of Stage 3 in an important way. If the analysis relied only on Moran's I, the conclusion would be that there is no statistically significant district-scale clustering. However, the map shows a more policy-relevant pattern: halal facilities are not spread evenly across the city, but are often located near the urban mobility system. In tourism terms, this means that Muslim-friendly infrastructure may be emerging along visitor-accessible routes rather than across broad administrative zones. This is especially meaningful in Taipei, where MRT accessibility can reduce the burden of walking distance by linking hotels, restaurants, attractions, and prayer spaces across multiple central districts.

Figure 3. Stage 3 KDE concentration map with MRT station proximity overlay.

5.4 Stage 4: Ecosystem Qualification

Stage 4 directly answers whether hotel locations function as Muslim-friendly tourism ecosystems. Taipei has the highest qualification rate: 43 of 52 hotels, or 82.7 percent, qualify at the 1 km threshold. Kaohsiung ranks second, with 21 of 31 hotels, or 67.7 percent. Taichung ranks third, with 4 of 7 hotels, or 57.1 percent. At the stricter 500 m threshold, qualification rates fall to 44.2 percent in Taipei, 29.0 percent in Kaohsiung, and 28.6 percent in Taichung.
These results show that the presence of nearby attractions is less often the main constraint in Taipei and Kaohsiung; the bigger constraints are halal restaurant proximity in weaker districts and prayer facility proximity across all cities. Taipei has the strongest overall ecosystem because restaurant, attraction, and prayer layers overlap more frequently around hotels. Kaohsiung has strong hotel-attraction proximity but fewer prayer facilities and fewer standalone restaurants. Taichung's result is constrained by its small hotel sample and thinner overlap between hotels, restaurants, and attractions.
The 500 m threshold is particularly useful for identifying the difference between accessible and compact ecosystems. Taipei's 1 km qualification rate is high, but the rate falls to 44.2 percent at 500 m. This means that many Taipei hotels are located within a reasonable support zone, but fewer are embedded in a highly compact walking-scale ecosystem. Kaohsiung and Taichung fall to approximately 29 percent at 500 m, suggesting that their qualifying ecosystems are more fragile and more dependent on short transit trips or longer walks.
The ecosystem qualification results also highlight the difference between attraction access and religious-support access. Attractions are relatively close to many hotels in Taipei and Kaohsiung, but prayer facilities are not. This finding matters because Muslim-friendly tourism is not only a food-and-hotel issue. A city can appear strong in halal dining and accommodation but still provide an incomplete visitor experience if prayer spaces are sparse, poorly distributed, or not visible to tourists. In addition, proximity only becomes practical when visitors can identify the resources. Halal restaurants and prayer rooms that are close but poorly communicated may still be underused, while clearly mapped, well-reviewed, and socially recommended facilities can make the city feel easier to navigate.
City
Hotels
1 km qualified
1 km rate
500 m qualified
500 m rate
Prayer within 1 km
Kaohsiung
31
21
67.7%
9
29.0%
32.3%
Taichung
7
4
57.1%
2
28.6%
14.3%
Taipei
52
43
82.7%
23
44.2%
59.6%
 
Table 5. Stage 4 ecosystem qualification results.

City
Mean restaurants within 1 km
Mean attractions within 1 km
Mean prayer facilities within 1 km
Maximum attractions within 1 km
Kaohsiung
1.3
2.7
0.4
7
Taichung
1.7
1.1
0.1
2
Taipei
3.2
4.3
0.8
11
 
Table 6. Average nearby resources around halal-certified hotels.


Figure 4. Stage 4 ecosystem qualification map by hotel location.


Figure 5. Ecosystem qualification rates at 1 km and 500 m thresholds.


## Contributors

Le Thanh Thao, Tran Thi Minh Anh
## Acknowledgments


## References

Al-Ansi, A., & Han, H. (2019). Role of halal-friendly destination performances, value, satisfaction, and trust in generating destination loyalty. Journal of Destination Marketing & Management, 14, 100377.
Battour, M., & Ismail, M. N. (2016). Halal tourism: Concepts, practises, challenges and future. Tourism Management Perspectives, 19, 150-154.
Carboni, M., Perelli, C., & Sistu, G. (2014). Is Islamic tourism a viable option for Tunisian tourism? Insights from Djerba. Tourism Management Perspectives, 11, 1-9.
CrescentRating & Mastercard. (2024). Global Muslim Travel Index 2024. CrescentRating.
Henderson, J. C. (2016). Halal food, certification and halal tourism: Insights from Malaysia and Singapore. Tourism Management Perspectives, 19, 160-164.
Losurdo, R. (2022). A new niche in the Islamic tourism: Muslim friendly tourism. Journal of Modern Science, 49(2), 463-481.
Royanow, A. F., Rizkiyah, P., Muhtasom, A., Satiadji, A. R., Fahmi, S., Liu, L. W., & Pahrudin, P. (2024). Exploring the Muslim-friendly attributes in Taiwan toward travelers' visit decision: The moderating role of religiosity. Cogent Social Sciences, 10(1).
Taiwan Tourism Administration. (2026). Muslim-friendly environment, dining and accommodation data. Ministry of Transportation and Communications, Taiwan.
Taiwan Tourism Administration. (2026). Muslim-friendly Environment: Dining & Accommodation. https://eng.taiwan.net.tw/m1.aspx?sNo=0020323
Halal Formosa. (2026). Halal Formosa: Halal map and ingredient scanner in Taiwan. https://halalformosa.com
Taiwan Tourism Administration Open Data. (2026). Tourist attraction dataset. Ministry of Transportation and Communications, Taiwan.
Ministry of the Interior, Taiwan. (2026). Administrative boundary spatial data. National land and geospatial open data.
Litvin, S. W., Goldsmith, R. E., & Pan, B. (2008). Electronic word-of-mouth in hospitality and tourism management. Tourism Management, 29(3), 458-468.
Xiang, Z., & Gretzel, U. (2010). Role of social media in online travel information search. Tourism Management, 31(2), 179-188.
