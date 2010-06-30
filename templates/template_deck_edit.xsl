<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:am="http://arcomage.netvor.sk"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />


<xsl:template match="section[. = 'Deck_edit']">
	<xsl:variable name="param" select="$params/deck_edit" />

	<!-- remember the current location across pages -->
	<div>
		<input type="hidden" name="CurrentDeck" value="{$param/CurrentDeck}"/>
	</div>

	<div class="filters">

	<div id="cost_per_turn">
		<xsl:text>Avg cost / turn</xsl:text>
		<b><xsl:value-of select="$param/Res/Bricks"/></b>
		<b><xsl:value-of select="$param/Res/Gems"/></b>
		<b><xsl:value-of select="$param/Res/Recruits"/></b>
	</div>

	<!-- card rarity filter -->
	<xsl:variable name="classes">
		<value name="Common"   value="Common"   />
		<value name="Uncommon" value="Uncommon" />
		<value name="Rare"     value="Rare"     />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('ClassFilter', $param/ClassFilter, $classes, '')"/>

	<!-- card keyword filter -->
	<xsl:variable name="keywords">
		<value name="No keyword filter" value="none"        />
		<value name="Any keyword"       value="Any keyword" />
		<value name="No keywords"       value="No keywords" />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('KeywordFilter', $param/KeywordFilter, $keywords, $param/keywords)"/>

	<!-- cost filter -->
	<xsl:variable name="costs">
		<value name="No cost filter" value="none"  />
		<value name="Bricks only"    value="Red"   />
		<value name="Gems only"      value="Blue"  />
		<value name="Recruits only"  value="Green" />
		<value name="Zero cost"      value="Zero"  />
		<value name="Mixed cost"     value="Mixed" />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('CostFilter', $param/CostFilter, $costs, '')"/>

	<!-- advanced filter select menu - filters based upon appearance in card text -->
	<xsl:variable name="advanced">
		<value name="No adv. filter" value="none"          />
		<value name="Attack"         value="Attack:"       />
		<value name="Discard"        value="Discard"       />
		<value name="Replace"        value="Replace"       />
		<value name="Reveal"         value="Reveal"        />
		<value name="Production"     value="Production"    />
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
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('AdvancedFilter', $param/AdvancedFilter, $advanced, '')"/>

	<!-- support keyword filter -->
	<xsl:variable name="support">
		<value name="No support filter" value="none"        />
		<value name="Any keyword"       value="Any keyword" />
		<value name="No keywords"       value="No keywords" />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('SupportFilter', $param/SupportFilter, $support, $param/keywords)"/>

	<!-- creation date filter -->
	<xsl:variable name="created">
		<value name="No created filter" value="none" />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('CreatedFilter', $param/CreatedFilter, $created, $param/created_dates)"/>

	<!-- modification date filter -->
	<xsl:variable name="modified">
		<value name="No modified filter" value="none" />
	</xsl:variable>
	<xsl:copy-of select="am:htmlSelectBox('ModifiedFilter', $param/ModifiedFilter, $modified, $param/modified_dates)"/>

	<input type="submit" name="filter" value="Apply filters" />

	</div>	
	<div class="misc">

	<div id="tokens">
		<xsl:for-each select="$param/Tokens/*">
			<xsl:variable name="token" select="." />

			<select name="Token{position()}">
				<option value="none">
					<xsl:if test="$token = 'none'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:text>None</xsl:text>
				</option>
				<xsl:for-each select="$param/TokenKeywords/*">
					<option value="{text()}">
						<xsl:if test="$token = .">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="text()"/>
					</option>
				</xsl:for-each>
			</select>
		</xsl:for-each>

		<input type="submit" name="set_tokens" value="Set" />
		<input type="submit" name="auto_tokens" value="Auto" />
	</div>

	<input type="text" name="NewDeckName" value="{$param/CurrentDeck}" maxlength="20" />
	<input type="submit" name="rename_deck" value="Rename" />

	<xsl:choose>
		<xsl:when test="$param/reset = 'no'">
			<input type="submit" name="reset_deck_prepare" value="Reset" />
		</xsl:when>
		<xsl:otherwise>
			<input type="submit" name="reset_deck_confirm" value="Confirm reset" />
		</xsl:otherwise>
	</xsl:choose>

	<input type="submit" name="export_deck" value="Export" />
	<input name="uploadedfile" type="file" style="color: white"/>
	<input type="submit" name="import_deck" value="Import" />

	</div>

	<!-- cards in card pool -->
	<div class="scroll">
	<table cellpadding="0" cellspacing="0">
		<xsl:choose>
			<xsl:when test="count($param/CardList/*) &gt; 0">
				<tr valign="top">
					<xsl:for-each select="$param/CardList/*">
						<xsl:sort select="name" order="ascending"/>
						<td id="card_{id}" >
							<xsl:if test="excluded = 'no'">
								<xsl:attribute name="onclick">return TakeCard(<xsl:value-of select="id" />)</xsl:attribute>
								<xsl:copy-of select="am:cardstring(current(), $param/c_img, $param/c_keywords, $param/c_text, $param/c_oldlook)" />
							</xsl:if>
						</td>
					</xsl:for-each>
				</tr>
				<xsl:if test="$param/Take = 'yes'">
				<tr>
					<xsl:for-each select="$param/CardList/*">
						<xsl:sort select="name" order="ascending"/>
						<!-- if the deck's $classfilter section isn't full yet, display the button that adds the card -->
						<td><xsl:if test="excluded = 'no'"><noscript><div><input type="submit" name="add_card[{id}]" value="Take" /></div></noscript></xsl:if></td>
					</xsl:for-each>
				</tr>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<tr><td></td></tr>
			</xsl:otherwise>
		</xsl:choose>
	</table>
	</div>

	<!-- cards in deck -->
	<table class="deck skin_label" cellpadding="0" cellspacing="0" >

		<tr>
			<th><p>Common</p></th>
			<th><p>Uncommon</p></th>
			<th><p>Rare</p></th>
		</tr>

		<tr valign="top">
		<xsl:for-each select="$param/DeckCards/*"> <!-- Common, Uncommon, Rare sections -->
			<td>
				<table class="centered" cellpadding="0" cellspacing="0">
				<xsl:variable name="rarity" select="position()"/>
				<xsl:variable name="cards" select="."/>
				<xsl:for-each select="$cards/*[position() &lt;= 5]"> <!-- row counting hack -->
				<tr>
					<xsl:variable name="i" select="position()"/>
					<xsl:for-each select="$cards/*[position() &gt;= $i*3-2 and position() &lt;= $i*3]">
						<td id="slot_{(($i - 1) * 3) + position() + 15 * ($rarity - 1)}" >
							<xsl:if test="id &gt; 0"><xsl:attribute name="onclick">return RemoveCard(<xsl:value-of select="id" />)</xsl:attribute></xsl:if>
							<xsl:copy-of select="am:cardstring(current(), $param/c_img, $param/c_keywords, $param/c_text, $param/c_oldlook)" />
							<xsl:if test="id != 0">
								<noscript><div><input type="submit" name="return_card[{id}]" value="Return" /></div></noscript>
							</xsl:if>
						</td>
					</xsl:for-each>
				</tr>
				</xsl:for-each>
				</table>
			</td>
		</xsl:for-each>
		</tr>

	</table>
</xsl:template>


</xsl:stylesheet>
