<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool" exclude-result-prefixes="dtea xat xs"
    version="2.0">
    
    
    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="dtea:html.noteType">
        
        <xsl:choose>
            
            <xsl:when test="@type">
                <xsl:value-of select="@type"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="'generic'"/>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
   
    <xsl:function name="dtea:noteType">
        
        <xsl:param name="note"/>
        
        <xsl:apply-templates select="$note" mode="dtea:html.noteType"/>
        
    </xsl:function>
    
</xsl:stylesheet>