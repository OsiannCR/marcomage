<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:am="http://arcomage.netvor.sk"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />


<xsl:template match="section[. = 'Challenges']">
	<xsl:variable name="param" select="$params/challenges" />

	<div id="message_section">

	<!-- begin challenges -->

	<div id="challenges">

	<h3>Challenges</h3>

	<xsl:if test="$param/deck_count = 0">
		<p style="color: yellow">You need at least one ready deck to accept challenges.</p>
	</xsl:if>

	<xsl:if test="$param/startedgames &gt;= $param/max_games">
		<p style="color: yellow">You cannot start any more games.</p>
	</xsl:if>

	<p>	
		<input type="submit" name="incoming" value="Incoming">
			<xsl:if test="$param/current_subsection = 'incoming'">
				<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
		</input>

		<input type="submit" name="outgoing" value="Outgoing">
			<xsl:if test="$param/current_subsection = 'outgoing'">
				<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
		</input>
	</p>

	<xsl:choose>
		<xsl:when test="$param/challenges_count &gt; 0">
			<div class="challenge_box">
				<xsl:for-each select="$param/challenges/*">
					<div>
						<xsl:choose>
							<xsl:when test="$param/current_subsection = 'incoming'">
								<p><span>
									<xsl:if test="Online = 'yes'">
										<xsl:attribute name="style">color: lime</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="Author"/>
									</span> has challenged you on <span><xsl:value-of select="am:datetime(Created, $param/timezone)"/></span>.</p>
								<xsl:if test="Content != ''">
									<p class="challenge_content"><xsl:value-of select="Content"/></p>
								</xsl:if>
								<p>
									<xsl:if test="($param/deck_count &gt; 0) and ($param/max_games &gt; $param/startedgames)">
										<xsl:if test="$param/accept_challenges = 'yes'">
											<input type="submit" name="accept_challenge[{am:urlencode(Author)}]" value="Accept" />
										</xsl:if>
										<select name="AcceptDeck[{am:urlencode(Author)}]" size="1">
										<xsl:for-each select="$param/decks/*">
											<option value="{am:urlencode(.)}"><xsl:value-of select="."/></option>
										</xsl:for-each>
										</select>
									</xsl:if>
									<input type="submit" name="reject_challenge[{am:urlencode(Author)}]" value="Reject" />
								</p>
							</xsl:when>
							<xsl:when test="$param/current_subsection = 'outgoing'">
								<p>You challenged 
								<span>
									<xsl:if test="Online = 'yes'">
										<xsl:attribute name="style">color: lime</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="Recipient"/></span> on <span><xsl:value-of select="am:datetime(Created, $param/timezone)"/>
								</span>.</p>
								<xsl:if test="Content != ''">
									<p class="challenge_content"><xsl:value-of select="Content"/></p>
								</xsl:if>
								<p><input type="submit" name="withdraw_challenge2[{am:urlencode(Recipient)}]" value="Withdraw challenge" /></p>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:for-each>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<p>You have no <xsl:value-of select="$param/current_subsection"/> challenges.</p>
		</xsl:otherwise>
	</xsl:choose>

	</div>

	<!-- end challenges -->

	<!-- begin messages -->

	<div id="messages">

	<h3>Messages</h3>

	<!-- begin buttons and filters -->

	<div class="filters_trans" style="text-align: left;">
		<input type="submit" name="inbox" value="Inbox" >
			<xsl:if test="$param/current_location = 'inbox'">
				<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
		</input>
		<input type="submit" name="sent_mail" value="Sent mail" >
			<xsl:if test="$param/current_location = 'sent_mail'">
				<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
		</input>
		<xsl:if test="$param/see_all_messages = 'yes'" >
			<input type="submit" name="all_mail" value="All mail" >
				<xsl:if test="$param/current_location = 'all_mail'">
					<xsl:attribute name="style">border-color: lime</xsl:attribute>
				</xsl:if>
			</input>
		</xsl:if>

		<!-- begin date filter -->

		<select name="date_filter">
			<xsl:if test="$param/date_val != 'none'">
					<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
			<option value="none">
				<xsl:if test="$param/date_val = 'none'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				No date filter
			</option>
			<xsl:for-each select="$param/timesections/*">
				<option value="{time}">
					<xsl:if test="$param/date_val = time">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="text"/>
				</option>
			</xsl:for-each>
		</select>

		<!-- end date filter -->

		<xsl:if test="$param/messages_count &gt; 0">
		<!-- begin name filter -->

		<select name="name_filter">
			<xsl:if test="$param/name_val != 'none'">
				<xsl:attribute name="style">border-color: lime</xsl:attribute>
			</xsl:if>
			<option value="none">
				<xsl:if test="$param/name_val = 'none'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				No name filter
			</option>
			<xsl:for-each select="$param/name_filter/*">
				<option value="{am:urlencode(.)}">
					<xsl:if test="$param/name_val = .">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="text()"/>
				</option>
			</xsl:for-each>
		</select>

		<!-- end name filter -->
		</xsl:if>

		<input type = "submit" name = "message_filter" value = "Apply filters" />
	</div>

	<div class="filters_trans" style="text-align: left;">
	<!-- upper navigation -->
			<xsl:if test="$param/page_count &gt; 0">
				<!-- previous button -->
				<input type="submit" name="select_page_mes[{$param/current_page - 1}]" value="&lt;">
					<xsl:if test="$param/current_page &lt;= 0"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
				</input>

				<!-- next button -->
				<input type="submit" name="select_page_mes[{$param/current_page + 1}]" value="&gt;">
					<xsl:if test="$param/current_page &gt;= $param/page_count - 1"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
				</input>

				<!-- page selector -->
				<select name="jump_to_page">
					<xsl:for-each select="$param/pages/*">
						<option value="{.}">
							<xsl:if test="$param/current_page = ."><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="."/>
						</option>
					</xsl:for-each>
				</select>
				<input type="submit" name="Jump_messages" value="Select page" />
				<xsl:if test="$param/current_location != 'all_mail'">
					<input type="submit" name="Delete_mass" value="Delete selected" />
				</xsl:if>
			</xsl:if>

	<!-- end buttons and filters -->
	</div>

	<xsl:if test="($param/messages_count = 0) and (($param/date_val != 'none') or ($param/name_val != 'none'))">
		<p class="information_trans">No messages matched selected criteria.</p>
	</xsl:if>

	<xsl:if test="($param/messages_count = 0) and ($param/date_val = 'none') and ($param/name_val = 'none')">
		<p class="information_trans">You have no messages.</p>
	</xsl:if>

	<!-- begin messages table -->

	<xsl:if test="$param/messages_count &gt; 0">
		<table cellspacing="0">
			<!-- begin table header -->
			<tr>
				<th>
					<xsl:choose>
						<xsl:when test="$param/current_location = 'sent_mail'">
							<p>To<input class="details" type="submit" >
									<xsl:choose>
										<xsl:when test="(($param/current_condition = 'Recipient') and ($param/current_order = 'DESC'))">
											<xsl:attribute name="name">mes_ord_asc[Recipient]</xsl:attribute>
											<xsl:attribute name="value">\/</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="name">mes_ord_desc[Recipient]</xsl:attribute>
											<xsl:attribute name="value">/\</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="$param/current_condition = 'Recipient'">
										<xsl:attribute name="style">border-color: lime</xsl:attribute>
									</xsl:if>
								</input></p>
						</xsl:when>
						<xsl:otherwise>
							<p>From<input class="details" type="submit" >
									<xsl:choose>
										<xsl:when test="(($param/current_condition = 'Author') and ($param/current_order = 'DESC'))">
											<xsl:attribute name="name">mes_ord_asc[Author]</xsl:attribute>
											<xsl:attribute name="value">\/</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="name">mes_ord_desc[Author]</xsl:attribute>
											<xsl:attribute name="value">/\</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="$param/current_condition = 'Author'">
										<xsl:attribute name="style">border-color: lime</xsl:attribute>
									</xsl:if>
								</input></p>
						</xsl:otherwise>
					</xsl:choose>
				</th>
				<xsl:if test="$param/current_location = 'all_mail'">
					<th><p>To</p></th>
				</xsl:if>
				<th><p>Subject</p></th>
				<th>
					<p>Sent on<input class="details" type="submit" >
					<xsl:choose>
						<xsl:when test="(($param/current_condition = 'Created') and ($param/current_order = 'DESC'))">
							<xsl:attribute name="name">mes_ord_asc[Created]</xsl:attribute>
							<xsl:attribute name="value">\/</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="name">mes_ord_desc[Created]</xsl:attribute>
							<xsl:attribute name="value">/\</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$param/current_condition = 'Created'">
						<xsl:attribute name="style">border-color: lime</xsl:attribute>
					</xsl:if>
					</input></p>
				</th>
				<th></th>
			</tr>
			<!-- end table header -->

			<!-- begin table body -->
			<xsl:for-each select="$param/messages/*">
				<tr class="table_row">
					<xsl:if test="$param/current_location = 'inbox'">
						<xsl:choose>
							<!-- TODO format time to seconds and independant of user timezone -->
							<xsl:when test="Unread = 'yes' and am:datediff(Created, $param/PreviousLogin) &lt;= 0">
								<xsl:attribute name="style">color: red</xsl:attribute>
							</xsl:when>
							<xsl:when test="Unread = 'yes'">
								<xsl:attribute name="style">color: orange</xsl:attribute>
							</xsl:when>
							<xsl:when test="Author = $param/system_name">
								<xsl:attribute name="style">color: #00bfff</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					<td>
						<p>
							<xsl:choose>
								<xsl:when test="$param/current_location = 'sent_mail'">
									<xsl:value-of select="Recipient"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Author"/>
								</xsl:otherwise>
							</xsl:choose>
						</p>
					</td>
					<xsl:if test="$param/current_location = 'all_mail'">
						<td><p><xsl:value-of select="Recipient"/></p></td>
					</xsl:if>
					<td><p><xsl:value-of select="Subject"/></p></td>
					<td><p><xsl:value-of select="am:datetime(Created, $param/timezone)"/></p></td>
					<td>
						<p style="text-align: left">
							<input class="details" type="submit" value="+" >
								<xsl:choose>
									<xsl:when test="$param/current_location = 'all_mail'">
										<xsl:attribute name="name">message_retrieve[<xsl:value-of select="MessageID"/>]</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="name">message_details[<xsl:value-of select="MessageID"/>]</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</input>
							<xsl:if test="$param/current_location != 'all_mail'">
								<input class="details" type="submit" name="message_delete[{MessageID}]" value="D" />
								<input type="checkbox" class="table_checkbox" name="Mass_delete_{position()}[{MessageID}]" />
							</xsl:if>
							<xsl:if test="(($param/send_messages = 'yes') and ($param/current_location = 'inbox') and (Author != $param/system_name) and (Author != $param/PlayerName))">
								<input class="details" type="submit" name="message_create[{Author}]" value="R" />
							</xsl:if>
						</p>
					</td>
				</tr>
			</xsl:for-each>
			<!-- end table body -->
		</table>
	</xsl:if>

	<!-- end messages table -->

	</div>

	<!-- end messages -->

	<div class="clear_floats"></div>

	<input type="hidden" name="CurrentLocation" value="{$param/current_location}" />
	<input type="hidden" name="CurrentFilterDate" value="{$param/date_val}" />
	<input type="hidden" name="CurrentFilterName" value="{$param/name_val}" />
	<input type="hidden" name="CurrentMesPage" value="{$param/current_page}" />

	</div>

</xsl:template>


<xsl:template match="section[. = 'Message_details']">
	<xsl:variable name="param" select="$params/message_details" />

	<div id="mes_details">

	<h3>Message details</h3>

	<div>
		<img class="stamp_picture" src="img/stamps/stamp{$param/Stamp}.png" width="100px" height="100px" alt="Marcopost stamp" />
		<p><span>From:</span><xsl:value-of select="$param/Author"/></p>
		<p><span>To:</span><xsl:value-of select="$param/Recipient"/></p>
		<p><span>Subject:</span><xsl:value-of select="$param/Subject"/></p>
		<p><span>Sent on:</span><xsl:value-of select="am:datetime($param/Created, $param/timezone)"/></p>
		<p>
			<xsl:if test="$param/current_location != 'all_mail'">
				<xsl:choose>
					<xsl:when test="$param/delete = 'no'">
						<input type="submit" name="message_delete[{$param/MessageID}]" value="Delete" />
					</xsl:when>
					<xsl:otherwise>
						<input type="submit" name="message_delete_confirm[{$param/MessageID}]" value="Confirm delete" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="($param/messages = 'yes') and ($param/Recipient = $param/PlayerName) and ($param/Author != $param/system_name) and ($param/Author != $param/PlayerName)">
				<input type="submit" name="message_create[{am:urlencode($param/Author)}]" value="Reply" />
			</xsl:if>
			<input type="submit" name="message_cancel" value="Back" />
		</p>
		<hr/>
		<p><xsl:value-of select="$param/Content"/></p>
	</div>
	<input type="hidden" name="CurrentLocation" value="{$param/current_location}" />

	</div>

</xsl:template>


<xsl:template match="section[. = 'Message_new']">
	<xsl:variable name="param" select="$params/message_new" />

	<div id="mes_details">

	<h3>New message</h3>

	<div>
		<img class="stamp_picture" src="img/stamps/stamp0.png" width="100px" height="100px" alt="Marcopost stamp" />
		<p><span>From:</span><xsl:value-of select="$param/Author"/></p>
		<p><span>To:</span><xsl:value-of select="$param/Recipient"/></p>
		<p>
			<span>Subject:</span>
			<input class="text_data" type="text" name="Subject" maxlength="30" size="25" value="{$param/Subject}" />
		</p>
		<input type="submit" name="message_send" value="Send" />
		<input type="submit" name="message_cancel" value="Discard" />
		<hr/>

		<textarea name="Content" rows="6" cols="50"><xsl:value-of select="$param/Content"/></textarea>
	</div>

	<input type="hidden" name="Author" value="{$param/Author}" />
	<input type="hidden" name="Recipient" value="{$param/Recipient}" />

	</div>

</xsl:template>


</xsl:stylesheet>