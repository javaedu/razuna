<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->
<!--- Storage Decision --->
<!---
<cfif application.razuna.storage EQ "nirvanix">
	<cfset thestorage = "#application.razuna.nvxurlservices#/#attributes.nvxsession#/razuna/#session.hostid#/">
<cfelse>
--->
	<cfset thestorage = "#cgi.context_path#/assets/#session.hostid#/">
<!--- </cfif> --->
<cfoutput>
	<form name="form#col_id#" id="form#col_id#" method="post" action="#self#">
	<input type="hidden" name="#theaction#" value="#xfa.save#">
	<input type="hidden" name="langcount" value="#valuelist(qry_langs.lang_id)#">
	<input type="hidden" name="folder_id" value="#attributes.folder_id#">
	<input type="hidden" name="col_id" value="#attributes.col_id#">
	<input type="hidden" name="assetids" value="#valuelist(qry_assets.cart_product_id)#">
	<div id="col_detail#col_id#">
		<ul>
			<li><a href="##colassets">#defaultsObj.trans("collection_assets")# (<cfif qry_assets.recordcount EQ "">0<cfelse>#qry_assets.recordcount#</cfif>)</a></li>
			<cfif session.folderaccess NEQ "R">
				<li><a href="##detaildesc">#defaultsObj.trans("asset_desc")#</a></li>
				<li><a href="##settings">#defaultsObj.trans("settings")# & #defaultsObj.trans("share_header")#</a></li>
				<li><a href="##widgets" onclick="loadcontent('widgets','#myself#c.widgets&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#');">#defaultsObj.trans("header_widget")#</a></li>
			</cfif>
		</ul>
		<div id="colassets">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" class="grid">
				<cfloop query="qry_assets">
					<cfset myid = cart_product_id>
					<cfset theart = col_file_format>
					<cfset filename = filename>
					<cfswitch expression="#col_file_type#">
						<!--- IMAGES --->
						<cfcase value="img">
							<tr class="list">
								<td width="1%" nowrap="true" class="thumbview">
									<cfloop query="qry_theimage">
										<cfif myid EQ img_id>
											<a href="##" onclick="showwindow('#myself##xfa.detailimg#&file_id=#img_id#&what=images&loaddiv=content&folder_id=#attributes.folder_id#','#Jsstringformat(filename)#',1000,1);return false;">
											<cfif link_kind NEQ "url">
												<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix">
													<img src="#cloud_url#" border="0">
												<cfelse>
													<img src="#thestorage##path_to_asset#/thumb_#img_id#.#thumb_extension#" border="0">
												</cfif>
											<cfelseif link_kind EQ "url">
												<img src="#link_path_url#" border="0">
											</cfif>
											</a>
										</cfif>
									</cfloop>
								</td>
								<td width="100%" colspan="2" valign="top" class="gridno">
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td colspan="2" style="padding-bottom:7px;"><strong>#filename#</strong></td>
										</tr>
										<cfloop query="qry_theimage">
											<cfif myid EQ img_id>
												<!--- Original --->
												<tr>
													<td><input type="radio" name="artofimage#myid#" value="#myid#-original"<cfif theart EQ "original" OR qry_theimage_related.recordcount EQ 0> checked="true"</cfif> /></td>
													<td width="100%">Original<cfif link_kind NEQ "url"> #ucase(img_extension)# (#defaultsObj.converttomb("#ilength#")# MB) (#orgwidth#x#orgheight# pixel)</cfif><cfif link_kind EQ "url"> <em>(#defaultsObj.trans("link_is_url")#)</em></cfif></td>
												</tr>
												<!--- Thumbnail --->
												<cfif link_kind NEQ "url">
													<tr>
														<td width="1%"><input type="radio" name="artofimage#myid#" value="#myid#-thumb"<cfif theart EQ "thumb"> checked</cfif> /></td>
														<td width="100%">#defaultsObj.trans("preview")# #ucase(thumb_extension)# (#thumbwidth#x#thumbheight# pixel)</td>
													</tr>
												</cfif>
											</cfif>
										</cfloop>
										<!--- List the converted formats --->
										<cfloop query="qry_theimage_related">
											<cfif myid EQ img_group>
												<tr>
													<td><input type="radio" name="artofimage#myid#" value="#myid#-#img_id#"<cfif theart EQ img_id> checked</cfif> /></td>
													<td width="100%">#ucase(img_extension)# #defaultsObj.converttomb("#ilength#")# MB (#orgwidth#x#orgheight# pixel)</td>
												</tr>
											</cfif>
										</cfloop>
									</table>
								</td>
								<!--- move --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif col_item_order NEQ 1><cfset moveto=col_item_order - 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_up.gif" width="15" height="15" border="0" align="middle"></a></cfif><cfif col_item_order NEQ qry_assets.recordcount><cfset moveto=col_item_order + 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_down.gif" width="15" height="15" border="0" align="middle"></a></cfif></td>
								<!--- trash --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif session.folderaccess EQ "X"><a href="##" onclick="colupdate();showwindow('#myself##xfa.remove#&id=#myid#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&order=#col_item_order#','#Jsstringformat(defaultsObj.trans("remove"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a></cfif></td>
							</tr>
						</cfcase>
						<!--- VIDEOS --->
						<cfcase value="vid">
							<tr class="list">
								<td width="1%" nowrap="true" class="thumbview">
									<cfloop query="qry_thevideo">
										<cfif myid EQ vid_id>
											<a href="##" onclick="showwindow('#myself##xfa.detailvid#&file_id=#vid_id#&what=videos&loaddiv=content&folder_id=#attributes.folder_id#','#Jsstringformat(filename)#',1000,1);return false;">
											<cfif link_kind NEQ "url">
												<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix">
													<img src="#cloud_url#" border="0">
												<cfelse>
													<img src="#thestorage##path_to_asset#/#vid_name_image#" border="0">
												</cfif>
											<cfelseif link_kind EQ "url">
												<img src="#dynpath#/global/host/dam/images/icons/icon_movie.png" border="0">
											</cfif>
											</a>
										</cfif>
									</cfloop>
								</td>
								<td width="100%" colspan="2" valign="top" class="gridno">
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td colspan="2" style="padding-bottom:7px;"><strong>#filename#</strong></td>
										</tr>
										<cfloop query="qry_thevideo">
											<cfif myid EQ vid_id>
												<!--- The Original video --->
												<tr>
													<td width="1%"><input type="radio" name="artofvideo#myid#" value="#myid#-video"<cfif theart EQ "video" OR qry_thevideo_related.recordcount EQ 0> checked</cfif> /></td>
													<td width="100%">Original<cfif link_kind NEQ "url"> #ucase(vid_extension)# (#defaultsObj.converttomb("#vlength#")# MB) (#vwidth#x#vheight# pixel)</cfif><cfif link_kind EQ "url"> <em>(#defaultsObj.trans("link_is_url")#)</em></cfif></td>
												</tr>
												<!--- The preview video --->
												<tr>
													<td width="1%"><input type="radio" name="artofvideo#myid#" value="#myid#-video_preview"<cfif theart EQ "video_preview"> checked</cfif> /></td>
													<td width="100%">#defaultsObj.trans("preview")# #ucase(vid_extension)# (#vid_preview_width#x#vid_preview_heigth# pixel)</td>
												</tr>
											</cfif>
										</cfloop>
										<!--- List the converted formats --->
										<cfloop query="qry_thevideo_related">
											<cfif myid EQ vid_group>
												<tr>
													<td width="1%"><input type="radio" name="artofvideo#myid#" value="#myid#-#vid_id#"<cfif theart EQ vid_id> checked</cfif> /></td>
													<td width="100%">#ucase(vid_extension)# #defaultsObj.converttomb("#vlength#")# MB (#vwidth#x#vheight# pixel)</td>
												</tr>
											</cfif>
										</cfloop>
									</table>
								</td>
								<!--- move --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif col_item_order NEQ 1><cfset moveto=col_item_order - 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_up.gif" width="15" height="15" border="0" align="middle"></a></cfif><cfif col_item_order NEQ qry_assets.recordcount><cfset moveto=col_item_order + 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_down.gif" width="15" height="15" border="0" align="middle"></a></cfif></td>
								<!--- trash --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif session.folderaccess EQ "X"><a href="##" onclick="colupdate();showwindow('#myself##xfa.remove#&id=#myid#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&order=#col_item_order#','#Jsstringformat(defaultsObj.trans("remove"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a></cfif></td>
							</tr>
						</cfcase>
						<!--- AUDIOS --->
						<cfcase value="aud">
							<tr class="list">
								<td width="1%" nowrap="true" class="thumbview">
									<cfloop query="qry_theaudio">
										<cfif myid EQ aud_id>
											<a href="##" onclick="showwindow('#myself##xfa.detailaud#&file_id=#aud_id#&what=audios&loaddiv=content&folder_id=#attributes.folder_id#','#Jsstringformat(filename)#',1000,1);return false;"><img src="#dynpath#/global/host/dam/images/icons/icon_<cfif aud_extension EQ "mp3" OR aud_extension EQ "wav">#aud_extension#<cfelse>aud</cfif>.png" border="0"></a>
										</cfif>
									</cfloop>
								</td>
								<td width="100%" colspan="2" valign="top" class="gridno">
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td colspan="2" style="padding-bottom:7px;"><strong>#filename#</strong></td>
										</tr>
										<cfloop query="qry_theaudio">
											<cfif myid EQ aud_id>
												<tr>
													<td width="1%"><input type="radio" name="artofaudio#myid#" value="#myid#-audio"<cfif theart EQ "audio" OR qry_theaudio_related.recordcount EQ 0> checked</cfif> /></td>
													<td width="100%">Original<cfif link_kind NEQ "url"> #ucase(aud_extension)# (#defaultsObj.converttomb("#aud_size#")# MB)</cfif><cfif link_kind EQ "url"> <em>(#defaultsObj.trans("link_is_url")#)</em></cfif></td>
												</tr>
											</cfif>
										</cfloop>
										<!--- List the converted formats --->
										<cfloop query="qry_theaudio_related">
											<cfif myid EQ aud_group>
												<tr>
													<td width="1%"><input type="radio" name="artofaudio#myid#" value="#myid#-#aud_id#"<cfif theart EQ aud_id> checked</cfif> /></td>
													<td width="100%">#ucase(aud_extension)# (#defaultsObj.converttomb("#aud_size#")# MB)</td>
												</tr>
											</cfif>
										</cfloop>
									</table>
								</td>
								<!--- move --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif col_item_order NEQ 1><cfset moveto=col_item_order - 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_up.gif" width="15" height="15" border="0" align="middle"></a></cfif><cfif col_item_order NEQ qry_assets.recordcount><cfset moveto=col_item_order + 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_down.gif" width="15" height="15" border="0" align="middle"></a></cfif></td>
								<!--- trash --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif session.folderaccess EQ "X"><a href="##" onclick="colupdate();showwindow('#myself##xfa.remove#&id=#myid#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&order=#col_item_order#','#Jsstringformat(defaultsObj.trans("remove"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a></cfif></td>
							</tr>
						</cfcase>
						<!--- FILES --->
						<cfdefaultcase>
							<tr class="list">
								<td width="1%" nowrap="true" valign="top" class="thumbview">
									<cfloop query="qry_thefile">
										<cfif myid EQ file_id>
											<a href="##" onclick="showwindow('#myself##xfa.detaildoc#&file_id=#file_id#&what=files&loaddiv=content&folder_id=#attributes.folder_id#','#Jsstringformat(filename)#',1000,1);return false;">
											<!--- If it is a PDF we show the thumbnail --->
											<cfif (application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix") AND file_extension EQ "PDF">
												<img src="#cloud_url#" border="0">
											<cfelseif application.razuna.storage EQ "local" AND file_extension EQ "PDF">
												<cfset thethumb = replacenocase(file_name_org, ".pdf", ".jpg", "all")>
												<cfif FileExists("#ExpandPath("../../")#assets/#session.hostid#/#path_to_asset#/#thethumb#") IS "no">
													<img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" border="0">
												<cfelse>
													<img src="#thestorage##path_to_asset#/#thethumb#" border="0">
												</cfif>
											<cfelse>
												<cfif FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#file_extension#.png") IS "no"><img src="#dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" width="128" height="128" border="0"></cfif>
											</cfif>
											</a>
										</cfif>
									</cfloop>
								</td>
								<td width="100%" colspan="2" valign="top">
								<strong>#filename#</strong>
								<cfloop query="qry_thefile">
									<cfif myid EQ file_id AND link_kind EQ "url">
										<br /><em>(#defaultsObj.trans("link_is_url")#)</em>
									</cfif>
								</cfloop>
								</td>
								<!--- move --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif col_item_order NEQ 1><cfset moveto=col_item_order - 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_up.gif" width="15" height="15" border="0" align="middle"></a></cfif><cfif col_item_order NEQ qry_assets.recordcount><cfset moveto=col_item_order + 1><a href="##" onclick="colupdate();loadcontent('rightside','#myself##xfa.move#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&currentorder=#col_item_order#&moveto=#moveto#');return false;"><img src="#dynpath#/global/host/dam/images/arrow_down.gif" width="15" height="15" border="0" align="middle"></a></cfif></td>
								<!--- trash --->
								<td width="1%" align="center" nowrap="nowrap" valign="top"><cfif session.folderaccess EQ "X"><a href="##" onclick="colupdate();showwindow('#myself##xfa.remove#&id=#myid#&col_id=#attributes.col_id#&folder_id=#attributes.folder_id#&order=#col_item_order#','#Jsstringformat(defaultsObj.trans("remove"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a></cfif></td>
							</tr>
						</cfdefaultcase>
					</cfswitch>
				</cfloop>
				<cfif session.folderaccess NEQ "R">
					<tr>
						<td colspan="5"><div style="float:right;"><input type="submit" name="submit" value="#defaultsObj.trans("button_save")#" class="button"></div></td>
					</tr>
				</cfif>
			</table>
		</div>
		<cfif session.folderaccess NEQ "R">
			<!--- Desc and Keywords --->
			<div id="detaildesc">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" class="grid">
					<tr>
						<th colspan="2">#defaultsObj.trans("header_collection_name")#</th>
					</tr>
					<tr>
						<td>#defaultsObj.trans("header_collection_name")#</td>
						<td><input type="text" name="collectionname" style="width:400px;" value="#qry_detail.col_name#"></td>
					</tr>
					<tr>
						<td>ID</td>
						<td>#attributes.col_id#</td>
					</tr>
					<tr>
						<td colspan="2" class="list"></td>
					</tr>
					<tr>
						<th colspan="2">#defaultsObj.trans("asset_desc")#</th>
					</tr>
					<cfloop query="qry_langs">
					<cfset thisid = lang_id>
						<tr>
							<td class="td2" valign="top" width="1%" nowrap="true">#lang_name#: #defaultsObj.trans("description")#</td>
							<td class="td2" width="100%"><textarea name="col_desc_#thisid#" class="text" style="width:400px;height:50px;"><cfloop query="qry_detail"><cfif lang_id_r EQ thisid>#col_desc#</cfif></cfloop></textarea></td>
						</tr>
						<tr>
							<td class="td2" valign="top" width="1%" nowrap="true">#lang_name#: #defaultsObj.trans("keywords")#</td>
							<td class="td2" width="100%"><textarea name="col_keywords_#thisid#" class="text" style="width:400px;height:50px;"><cfloop query="qry_detail"><cfif lang_id_r EQ thisid>#col_keywords#</cfif></cfloop></textarea></td>
						</tr>
					</cfloop>
					<!--- Labels --->
					<tr>
						<td>#defaultsObj.trans("labels")#</td>
						<td width="100%" nowrap="true" colspan="5"><input name="tags" id="tags_col" value="#qry_labels#"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="5" style="padding-bottom:10px;"><em>(<cfif settingsobj.get_label_set().set2_labels_users EQ "f">You can only choose from available labels. Simply start typing to select from available labels.<cfelse>Simple start typing to choose from available labels or add a new one by entering above and hit ",".</cfif>)</em></td>
					</tr>
					<tr>
						<td colspan="2"><div style="float:right;padding:10px;"><input type="submit" name="submit" value="#defaultsObj.trans("button_save")#" class="button"></div></td>
					</tr>
				</table>
			</div>
			<!--- Settings --->
			<div id="settings">
				<!--- Groups and Permission --->
				<table border="0" cellpadding="0" cellspacing="0" width="100%" class="grid">
					<tr>
						<th width="100%" colspan="2">#defaultsObj.trans("access_for")#</th>
						<th width="1%" nowrap align="center">#defaultsObj.trans("per_read")#</th>
						<th width="1%" nowrap align="center">#defaultsObj.trans("per_read_write")#</th>
						<th width="1%" nowrap align="center">#defaultsObj.trans("per_all")#</th>
					</tr>
					<tr class="list">
						<td width="1%" align="center" style="padding:4px;"><input type="checkbox" name="grp_0" value="0" <cfif qry_col_groups_zero.grp_id_r EQ 0> checked</cfif> onclick="checkradio(0);"></td>
						<td width="100%" nowrap class="textbold" style="padding:4px;">#defaultsObj.trans("everybody")#</td>
						<td width="1%" nowrap align="center" style="padding:4px;"><input type="radio" value="R" name="per_0" id="per_0"<cfif (qry_col_groups_zero.grp_permission EQ "R") OR (qry_col_groups_zero.grp_permission EQ "")> checked</cfif>></td>
						<td width="1%" nowrap align="center" style="padding:4px;"><input type="radio" value="W" name="per_0"<cfif qry_col_groups_zero.grp_permission EQ "W"> checked</cfif>></td>
						<td width="1%" nowrap align="center" style="padding:4px;"><input type="radio" value="X" name="per_0"<cfif qry_col_groups_zero.grp_permission EQ "X"> checked</cfif>></td>
					</tr>
					<cfloop query="qry_groups">
						<tr class="list">
							<td width="1%" align="center" style="padding:4px;"><input type="checkbox" name="grp_#grp_id#" value="#grp_id#"<cfloop query="qry_col_groups"><cfif grp_id_r EQ #qry_groups.grp_id#> checked</cfif></cfloop> onclick="checkradio('#grp_id#');"></td>
							<td width="1%" nowrap style="padding:4px;">#grp_name#</td>
							<td align="center" style="padding:4px;"><input type="radio" value="R" name="per_#grp_id#" id="per_#grp_id#"<cfloop query="qry_col_groups"><cfif grp_id_r EQ #qry_groups.grp_id# AND grp_permission EQ "R"> checked<cfelseif grp_id_r NEQ #qry_groups.grp_id#> checked</cfif></cfloop>></td>
							<td align="center" style="padding:4px;"><input type="radio" value="W" name="per_#grp_id#"<cfloop query="qry_col_groups"><cfif grp_id_r EQ #qry_groups.grp_id# AND grp_permission EQ "W"> checked</cfif></cfloop>></td>
							<td align="center" style="padding:4px;"><input type="radio" value="X" name="per_#grp_id#"<cfloop query="qry_col_groups"><cfif grp_id_r EQ #qry_groups.grp_id# AND grp_permission EQ "X"> checked</cfif></cfloop>></td>
						</tr>
					</cfloop>
				</table>
				<br />
				<!--- Share Collection --->
				<table border="0" cellpadding="0" cellspacing="0" style="width:660px;" class="grid">
					<tr>
						<th colspan="2">#defaultsObj.trans("share_folder")#</th>
					</tr>
					<tr>
						<td colspan="2">#defaultsObj.trans("share_collection_desc")#</td>
					</tr>
					<tr>
						<td class="td2">#defaultsObj.trans("share_collection")#</td>
						<td class="td2"><input type="radio" value="T" name="col_shared"<cfif qry_detail.col_shared EQ "T"> checked="true"</cfif>>#defaultsObj.trans("yes")# <input type="radio" value="F" name="col_shared"<cfif qry_detail.col_shared EQ "F" OR qry_detail.col_shared EQ ""> checked="true"</cfif>>#defaultsObj.trans("no")#</td>
					</tr>
					<tr>
						<td class="td2" valign="top">#defaultsObj.trans("collection")# URL</td>
						<td class="td2"><!--- http://#cgi.http_host##replacenocase(cgi.script_name,"/index.cfm","","ALL")#/sharec/#attributes.col_id#/<input type="text" id="col_name_shared" name="col_name_shared" size="20" value="#qry_detail.col_name_shared#"><br /> ---><a href="http://#cgi.http_host##cgi.script_name#?fa=c.sharec&fid=#attributes.col_id#&v=#createuuid()#" target="_blank">http://#cgi.http_host##cgi.script_name#?fa=c.sharec&fid=#attributes.col_id#</a></td>
					</tr>
					<!--- Download Original --->
					<tr>
						<td colspan="2" class="list"></td>
					</tr>
					<tr>
						<td colspan="2"><strong>#defaultsObj.trans("share_allow_download_original")#</strong></td>
					</tr>
					<tr>
						<td colspan="2" class="td2">#defaultsObj.trans("share_allow_download_desc")#</td>
					</tr>
					<tr>
						<td class="td2" nowrap="nowrap" valign="top">#defaultsObj.trans("share_allow_download_original")#</td>
						<td class="td2"><input type="radio" value="T" name="share_dl_org" id="share_dl_org"<cfif qry_detail.share_dl_org EQ "T"> checked="true"</cfif>>#defaultsObj.trans("yes")# <input type="radio" value="F" name="share_dl_org" id="share_dl_org"<cfif qry_detail.share_dl_org EQ "F"> checked="true"</cfif>>#defaultsObj.trans("no")#
						<br><br>
						<a href="##" onclick="resetdl();return false;">#defaultsObj.trans("share_folder_download_reset")#</a>
						<div id="reset_dl" style="color:green;font-weight:bold;padding-top:5px;"></div>
						</td>
					</tr>
					<!--- Comments --->
					<tr>
						<td colspan="2" class="list"></td>
					</tr>
					<tr>
						<td colspan="2"><strong>#defaultsObj.trans("share_allow_commenting")#</strong></td>
					</tr>
					<tr>
						<td class="td2">#defaultsObj.trans("share_allow_commenting")#</td>
						<td class="td2"><input type="radio" value="T" name="share_comments"<cfif qry_detail.share_comments EQ "T"> checked="true"</cfif>>#defaultsObj.trans("yes")# <input type="radio" value="F" name="share_comments"<cfif qry_detail.share_comments EQ "F"> checked="true"</cfif>>#defaultsObj.trans("no")#</td>
					</tr>
					<!--- Upload --->
					<tr>
						<td colspan="2" class="list"></td>
					</tr>
					<tr>
						<td colspan="2"><strong>#defaultsObj.trans("share_allow_upload")#</strong></td>
					</tr>
					<tr>
						<td colspan="2" class="td2">#defaultsObj.trans("share_allow_upload_desc")#</td>
					</tr>
					<tr>
						<td class="td2">#defaultsObj.trans("share_allow_upload")#</td>
						<td class="td2"><input type="radio" value="T" name="share_upload"<cfif qry_detail.share_upload EQ "T"> checked="true"</cfif>>#defaultsObj.trans("yes")# <input type="radio" value="F" name="share_upload"<cfif qry_detail.share_upload EQ "F"> checked="true"</cfif>>#defaultsObj.trans("no")#</td>
					</tr>
					<!--- Order --->
					<tr>
						<td colspan="2" class="list"></td>
					</tr>
					<tr>
						<td colspan="2"><strong>#defaultsObj.trans("share_allow_order")#</strong></td>
					</tr>
					<tr>
						<td colspan="2" class="td2">#defaultsObj.trans("share_allow_order_desc")#</td>
					</tr>
					<tr>
						<td class="td2">#defaultsObj.trans("share_allow_order")#</td>
						<td class="td2"><input type="radio" value="T" name="share_order"<cfif qry_detail.share_order EQ "T"> checked="true"</cfif>>#defaultsObj.trans("yes")# <input type="radio" value="F" name="share_order"<cfif qry_detail.share_order EQ "F"> checked="true"</cfif>>#defaultsObj.trans("no")#</td>
					</tr>
					<tr>
						<td colspan="2" class="td2">#defaultsObj.trans("share_allow_order_email_desc")#</td>
					</tr>
					<tr>
						<td class="td2">#defaultsObj.trans("share_allow_order_email")#</td>
						<td class="td2">
							<select data-placeholder="Choose a User" class="chzn-select" style="width:250px;" name="share_order_user">
								<option value=""></option>
								<cfloop query="qry_users">
									<option value="#user_id#"<cfif qry_detail.share_order_user EQ user_id> selected</cfif>>#user_first_name# #user_last_name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2"><div style="float:right;padding:10px;"><input type="submit" name="submit" value="#defaultsObj.trans("button_save")#" class="button"></div></td>
					</tr>
				</table>
			</div>
			<!--- Widgets --->
			<div id="widgets"></div>
		</div>
		<div id="updatecol" style="width:80%;float:left;padding:10px;color:green;font-weight:bold;display:none;"></div>
	</cfif>
	</form>
	<!--- JS --->
	<script language="JavaScript" type="text/javascript">
		// Initialize Tabs
		jqtabs("col_detail#col_id#");
		// Submit Form
		$("##form#col_id#").submit(function(e){
			$("##updatecol").css("display","");
			loadinggif('updatecol');
			// Submit Form
			// Get values
			var url = formaction("form#col_id#");
			var items = formserialize("form#col_id#");
			// Submit Form
			$.ajax({
				type: "POST",
				url: url,
			   	data: items,
			   	success: function(){
					$("##updatecol").html('#JSStringFormat(defaultsObj.trans("update_collection_done"))#');
					$("##updatecol").animate({opacity: 1.0}, 3000).fadeTo("slow", 0.33);
			   	}
			});
			return false;
		})
		// When we move a item we issue a save first
		function colupdate(){
			// Get values
			var url = formaction("form#col_id#");
			var items = formserialize("form#col_id#");
			// Submit Form
			$.ajax({
				type: "POST",
				url: url,
			   	data: items
			});
			return false;
		}
		// TAG IT
		var raztags = #attributes.thelabels#;
		// Global Tagit function
		// div, fileid, type, tags
		raztagit('tags_col','#attributes.col_id#','collection',raztags,'#settingsobj.get_label_set().set2_labels_users#');
		// Activate Chosen
		$(".chzn-select").chosen()
	</script>
</cfoutput>