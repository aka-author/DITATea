<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[contains(@class, ' task/step ')]" mode="dtea:html.markerContent">
        
        <xsl:value-of
            select="concat(count(preceding-sibling::*[contains(@class, ' task/step ')]) + 1, '.')"/>
        
    </xsl:template>


    <xsl:template match="*[contains(@class, ' task/substep ')]" mode="dtea:html.markerContent">
        
        <xsl:variable name="substepNumber"
            select="count(preceding-sibling::*[contains(@class, ' task/substep ')]) + 1"/>
        
        <xsl:variable name="alph" select="'abcdefghijklmnopqrstuvwxyz'"/>
        
        <xsl:value-of select="concat(substring($alph, $substepNumber, 1), ')')"/>
        
    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'task/step task/substep')]" mode="dtea:html.marker">
        <div>
            <xsl:apply-templates select="." mode="dtea:html.markerContent"/>
        </div>
    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'task/step task/substep')]" mode="dtea:html.body">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'task/step task/substep')]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs">
                <xsl:with-param name="directCSSClassName" select="'block dita__task step'"/>
            </xsl:apply-templates>

            <div>
                <xsl:apply-templates select="." mode="dtea:html.marker"/>
                <xsl:apply-templates select="." mode="dtea:html.body"/>
            </div>

        </div>

    </xsl:template>


    <xsl:template match="*[contains(@class, ' task/stepsection ')]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs">
                <xsl:with-param name="defaultCSSClassName" select="'block dita__task stepsection'"/>
            </xsl:apply-templates>

            <xsl:apply-templates/>

        </div>

    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'task/steps task/substeps')]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs">
                <xsl:with-param name="defaultCSSClassName" select="'block dita__task steps'"/>
            </xsl:apply-templates>

            <xsl:apply-templates/>

        </div>

    </xsl:template>


    <xsl:template match="*[dtea:hasClass(., 'task/steps-nformal task/substeps-unformal')]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs">
                <xsl:with-param name="defaultCSSClassName" select="'block task__steps'"/>
            </xsl:apply-templates>

            <xsl:apply-templates/>

        </div>

    </xsl:template>

</xsl:stylesheet>
