<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:am="http://arcomage.netvor.sk"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

<!-- includes -->
<xsl:include href="template_main.xsl" />


<xsl:template match="section[. = 'Cards']">
	<xsl:variable name="param" select="$params/cards" />

  <div id="cards">
		<!-- begin buttons and filters -->
		<xsl:choose>
			<xsl:when test="$param/is_logged_in = 'yes'">
			<!-- advanced navigation (for authenticated users only) -->
			<div class="filters">

			<!-- card name filter -->
			<input type="text" name="NameFilter" maxlength="20" size="15" value="{$param/NameFilter}" title="search phrase for card name (CASE sensitive, type first letter as capital if you want the card name to start with that letter)" />

			<!-- card rarity filter -->
			<xsl:variable name="classes">
				<value name="Common"   value="Common"   />
				<value name="Uncommon" value="Uncommon" />
				<value name="Rare"     value="Rare"     />
				<value name="Any"      value="none"     />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('ClassFilter', $param/ClassFilter, $classes, '', 'rarity filter')"/>

			<!-- card keyword filter -->
			<xsl:variable name="keywords">
				<value name="No keyword filter" value="none"        />
				<value name="Any keyword"       value="Any keyword" />
				<value name="No keywords"       value="No keywords" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('KeywordFilter', $param/KeywordFilter, $keywords, $param/keywords, 'keyword filter')"/>

			<!-- cost filter -->
			<xsl:variable name="costs">
				<value name="No cost filter" value="none"  />
				<value name="Bricks only"    value="Red"   />
				<value name="Gems only"      value="Blue"  />
				<value name="Recruits only"  value="Green" />
				<value name="Zero cost"      value="Zero"  />
				<value name="Mixed cost"     value="Mixed" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('CostFilter', $param/CostFilter, $costs, '', 'cost filter')"/>

			<!-- advanced filter select menu - filters based upon appearance in card text -->
			<xsl:variable name="advanced">
				<value name="No adv. filter" value="none"          />
				<value name="Attack"         value="Attack:"       />
				<value name="Discard"        value="Discard "      />
				<value name="Replace"        value="Replace "      />
				<value name="Reveal"         value="Reveal"        />
				<value name="Summon"         value="Summons"       />
				<value name="Production"     value="Prod"          />
				<value name="Persistent"     value="Replace a card in hand with self" />
				<value name="Wall +"         value="Wall: +"       />
				<value name="Wall -"         value="Wall: -"       />
				<value name="Tower +"        value="Tower: +"      />
				<value name="Tower -"        value="Tower: -"      />
				<value name="Facilities +"   value="Facilities: +" />
				<value name="Facilities -"   value="Facilities: -" />
				<value name="Magic +"        value="Magic: +"      />
				<value name="Magic -"        value="Magic: -"      />
				<value name="Quarry +"       value="Quarry: +"     />
				<value name="Quarry -"       value="Quarry: -"     />
				<value name="Dungeon +"      value="Dungeon: +"    />
				<value name="Dungeon -"      value="Dungeon: -"    />
				<value name="Stock +"        value="Stock: +"      />
				<value name="Stock -"        value="Stock: -"      />
				<value name="Gems +"         value="Gems: +"       />
				<value name="Gems -"         value="Gems: -"       />
				<value name="Bricks +"       value="Bricks: +"     />
				<value name="Bricks -"       value="Bricks: -"     />
				<value name="Recruits +"     value="Recruits: +"   />
				<value name="Recruits -"     value="Recruits: -"   />
				<value name="Random resources" value="random resource" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('AdvancedFilter', $param/AdvancedFilter, $advanced, '', 'advanced filter')"/>

			<!-- support keyword filter -->
			<xsl:variable name="support">
				<value name="No support filter" value="none"        />
				<value name="Any keyword"       value="Any keyword" />
				<value name="No keywords"       value="No keywords" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('SupportFilter', $param/SupportFilter, $support, $param/keywords, 'support keyword filter')"/>

			<!-- creation date filter -->
			<xsl:variable name="created">
				<value name="No created filter" value="none" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('CreatedFilter', $param/CreatedFilter, $created, $param/created_dates, 'date created filter')"/>

			<!-- modification date filter -->
			<xsl:variable name="modified">
				<value name="No modified filter" value="none" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('ModifiedFilter', $param/ModifiedFilter, $modified, $param/modified_dates, 'date modified filter')"/>

			<!-- card level filter -->
			<xsl:variable name="level">
				<value name="No level filter" value="none" />
			</xsl:variable>
			<xsl:copy-of select="am:htmlSelectBox('LevelFilter', $param/LevelFilter, $level, $param/levels, 'level filter')"/>

			<button type="submit" name="cards_filter" >Apply filters</button>
			</div>

			<!-- navigation -->
			<div class="filters"><xsl:copy-of select="am:upper_navigation($param/page_count, $param/current_page, 'cards')"/></div>

			</xsl:when>
			<xsl:otherwise>
				<!-- simple navigation (for anonymous users) -->
				<div class="filters"><xsl:copy-of select="am:simple_navigation('Cards', 'CurrentCardsPage', $param/current_page, $param/page_count)"/></div>
			</xsl:otherwise>
		</xsl:choose>
		<!-- end buttons and filters -->

		<table cellspacing="0" class="skin_text">
			<tr>
				<th>Card</th>
				<th><p>Card name</p></th>
				<th><p>Rarity</p></th>
				<th><p>Cost</p></th>
				<th><p>Level</p></th>
				<th><p>Effect</p></th>
				<th><p>Created</p></th>
				<th><p>Modified</p></th>
			</tr>
			<xsl:for-each select="$param/CardList/*">
				<tr>
					<td align="center"><xsl:copy-of select="am:cardstring(current(), $param/c_img, $param/c_oldlook, $param/c_insignias, $param/c_foils)" /></td>
					<td><p><a href="{am:makeurl('Cards_details', 'card', id)}"><xsl:value-of select="name"/></a></p></td>
					<td><p><xsl:value-of select="class"/></p></td>
					<td><p><xsl:value-of select="bricks" />/<xsl:value-of select="gems" />/<xsl:value-of select="recruits" /></p></td>
					<td><p><xsl:value-of select="level"/></p></td>
					<td><p class="effect"><xsl:value-of select="am:cardeffect(effect)" disable-output-escaping="yes"/></p></td>
					<td><p><xsl:value-of select="am:format-date(created)"/></p></td>
					<td><p><xsl:value-of select="am:format-date(modified)"/></p></td>
				</tr>
			</xsl:for-each>
		</table>

		<xsl:if test="$param/is_logged_in = 'yes'">
			<div class="filters">
				<!-- lower navigation -->
				<xsl:copy-of select="am:lower_navigation($param/page_count, $param/current_page, 'cards', 'Cards')"/>
			</div>
		</xsl:if>

		<input type="hidden" name="CurrentCardsPage" value="{$param/current_page}" />
  </div>

</xsl:template>


<xsl:template match="section[. = 'Cards_details']">
	<xsl:variable name="param" select="$params/cards_details" />

	<div id="cards_details">

		<div class="skin_text">
			<a class="button" href="{am:makeurl('Cards')}">Back</a>
			<xsl:choose>
				<xsl:when test="$param/discussion = 0 and $param/create_thread = 'yes'">
					<button type="submit" name="card_thread" value="{$param/data/id}" >Start discussion</button>
				</xsl:when>
				<xsl:when test="$param/discussion &gt; 0">
					<a class="button" href="{am:makeurl('Forum_thread', 'CurrentThread', $param/discussion, 'CurrentPage', 0)}">View discussion</a>
				</xsl:when>
			</xsl:choose>
      <xsl:if test="$param/is_logged_in = 'yes' and $param/foil_version = 'no'">
        <button type="submit" name="buy_foil" value="{$param/data/id}">Purchase foil version for <xsl:value-of select="$param/foil_cost"/> gold</button>
      </xsl:if>
			<hr />

			<div class="card_preview"><xsl:copy-of select="am:cardstring($param/data, $param/c_img, $param/c_oldlook, $param/c_insignias, $param/c_foils)" /></div>
			<div class="limit">
				<p><span><xsl:value-of select="$param/data/name"/></span>Name</p>
				<p><span><xsl:value-of select="$param/data/class"/></span>Rarity</p>
				<p><span><xsl:value-of select="$param/data/keywords"/></span>Keywords</p>
				<p><span><xsl:value-of select="$param/data/bricks"/>/<xsl:value-of select="$param/data/gems"/>/<xsl:value-of select="$param/data/recruits"/></span>Cost (B/G/R)</p>
				<p><span><xsl:value-of select="$param/data/modes"/></span>Modes</p>
				<p><span><xsl:value-of select="$param/data/level"/></span>Level</p>
				<p><span><xsl:value-of select="am:format-date($param/data/created)"/></span>Created</p>
				<p><span><xsl:value-of select="am:format-date($param/data/modified)"/></span>Modified</p>
				<p><span><xsl:value-of select="$param/statistics/Played"/> / <xsl:value-of select="$param/statistics/PlayedTotal"/></span>Played</p>
				<p><span><xsl:value-of select="$param/statistics/Discarded"/> / <xsl:value-of select="$param/statistics/DiscardedTotal"/></span>Discarded</p>
				<p><span><xsl:value-of select="$param/statistics/Drawn"/> / <xsl:value-of select="$param/statistics/DrawnTotal"/></span>Drawn</p>
			</div>
			<p>Effect</p>
			<div><xsl:value-of select="am:cardeffect($param/data/effect)" disable-output-escaping="yes"/></div>
			<hr />
			<p>Code</p>
			<div class="code"><pre><xsl:copy-of select="$param/data/code/text()" /></pre></div>
		</div>
	</div>

</xsl:template>


<xsl:template match="section[. = 'Cards_keywords']">
	<xsl:variable name="param" select="$params/cards_keywords" />
	<xsl:variable name="keywords" select="document('keywords.xml')/am:keywords" />

	<div id="keywords">
		<table cellspacing="0" class="skin_text">
			<tr>
				<th></th>
				<th><p>Name</p></th>
				<th><p>Effect</p></th>
			</tr>
			<xsl:for-each select="$keywords/*">
				<tr class="table_row">
					<td><p><img class="insignia" src="img/insignias/{am:file_name(am:name)}.png" width="12px" height="12px" alt="{am:name}" title="{am:name}" /></p></td>
					<td><p><a href="{am:makeurl('Cards_keyword_details', 'keyword', am:name)}"><xsl:value-of select="am:name"/></a></p></td>
					<td>
            <p class="description">
              <xsl:if test="am:basic_gain &gt; 0 or am:bonus_gain &gt; 0">
                <xsl:text>Basic gain </xsl:text>
                <xsl:value-of select="am:basic_gain"/>
                <xsl:text>, bonus gain </xsl:text>
                <xsl:value-of select="am:bonus_gain"/>
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="am:description"/>
            </p>
          </td>
				</tr>
			</xsl:for-each>
		</table>
	</div>

</xsl:template>


<xsl:template match="section[. = 'Cards_keyword_details']">
	<xsl:variable name="param" select="$params/keyword_details" />
	<xsl:variable name="keyword" select="document('keywords.xml')/am:keywords/am:keyword[am:name = $param/name]" />

	<xsl:choose>

	<xsl:when test="$keyword">
		<div id="keyword_details">
			<h3><a href="{am:makeurl('Cards_keywords')}">Keywords</a> &gt; <xsl:value-of select="$keyword/am:name"/></h3>
			<div class="skin_text">
				<h4>Effect</h4>
				<p class="description">
					<img class="insignia" src="img/insignias/{am:file_name($keyword/am:name)}.png" width="12px" height="12px" alt="{$keyword/am:name}" title="{$keyword/am:name}" />
          <xsl:if test="$keyword/am:basic_gain &gt; 0 or $keyword/am:bonus_gain &gt; 0">
            <xsl:text>Basic gain </xsl:text>
            <xsl:value-of select="$keyword/am:basic_gain"/>
            <xsl:text>, bonus gain </xsl:text>
            <xsl:value-of select="$keyword/am:bonus_gain"/>
            <xsl:text>, </xsl:text>
          </xsl:if>
					<xsl:value-of select="$keyword/am:description"/>
				</p>
				<h4>Lore</h4>
				<div class="lore"><xsl:value-of select="$keyword/am:lore" disable-output-escaping="yes" /></div>
				<hr />
				<h4>Code</h4>
				<div class="code"><pre><xsl:copy-of select="$keyword/am:code/text()"/></pre></div>
			</div>
		</div>
	</xsl:when>

	<xsl:otherwise>
		<h3 class="information_line error">Invalid keyword.</h3>
	</xsl:otherwise>

	</xsl:choose>

</xsl:template>


</xsl:stylesheet>
