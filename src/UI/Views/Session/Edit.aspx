﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Main.Master" AutoEventWireup="true" 
Inherits="CodeCampServer.UI.Helpers.ViewPage.SessionEditView"%>
<%@ Import Namespace="Microsoft.Web.Mvc"%>
<%@ Import Namespace="CodeCampServer.Core.Common"%>
<%@ Import Namespace="MvcContrib" %>
<%@ Import Namespace="System.Web.Mvc" %>
<%@ Import Namespace="System.Web.Mvc.Html"%>
<%@ Import Namespace="CodeCampServer.UI"%>

<%@ Import Namespace="CodeCampServer.UI.Models.Forms" %>
<%@ Import Namespace="CodeCampServer.UI.Controllers" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Stylesheets" runat="server">
	<script type="text/javascript" src="/scripts/jqModal.js"></script>
	<script type="text/javascript" src="/scripts/jquery.form.js"></script>
	<link id="jqModalCss" rel="Stylesheet" type="text/css" media="all" href="/css/jqModal.css" runat="server" />
</asp:Content>


<asp:Content ContentPlaceHolderID="Main" runat="server">
    <form action="<%= Url.Action<SessionController>(x => x.Save(null)) %>" method="post"  >
        <div>
			    <h1>Edit Session</h1>  
						<%=Errors.Display()%>
						<table class="dataEntry">
							<tr>
								<td class="w50p">
									<%=InputFor(a => a.Id)%>            	
									<%=InputFor(a => a.Title)%>
									<%=InputFor(a => a.Key)%>
									<%=InputFor(a => a.Abstract)%>
									<%=InputFor(a => a.Level)%>
									<%--<%=InputFor(a => a.Speaker)%>
									<%=InputFor(a => a.TimeSlot)%>
									<%=InputFor(a => a.Track)%>--%>
									<%=InputFor(a => a.RoomNumber)%>
									<%=InputFor(a => a.MaterialsUrl)%>
								</td>
							</tr>
						</table>
	        <br />
	        <br />
	        <div class="p10 tac">
						<%=Html.SubmitButton("save", "Save", new{@class="pr10 w100"}) %>    
						<a href="<%=Url.Action<AdminController>(x => x.Index()).ToXHTMLLink() %>"  class="pr10 mt5" rel="cancel">Cancel</a>				
					</div>
        </div>
    </form>
</asp:Content>